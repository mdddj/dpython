use std::ffi::CString;
use std::{env, fs};

use anyhow::{Context, Ok};
use flutter_rust_bridge::frb;
use pyo3::types::{PyDict, PyTuple};
use pyo3::{prelude::*, IntoPyObjectExt};

use pyo3::{types::PyModule, Py, PyAny, Python};

pub struct PythonUtility {}

impl PythonUtility {
    /// 获取模块的属性
    /// - `module_name`: 模块名称
    /// - `attr_name`: 属性名称

    pub fn get_module_attr(module_name: String, attr_name: String) -> anyhow::Result<String> {
        Python::attach(|py| {
            let module = PyModule::import(py, module_name)?;
            let result = module.getattr(attr_name)?.extract()?;
            Ok(result)
        })
    }

    /// 执行 Python 表达式，支持自定义 globals 和 locals 上下文
    ///
    /// - `code`: Python 代码
    /// - `globals`: 全局变量。传 None 则使用默认 __main__，传 [] 则创建纯净沙盒。
    /// - `locals`: 局部变量。传 None 则默认与 globals 相同。
    /// - `imports`: 需要预先导入的模块，会自动注入到上下文。

    pub fn eval(
        code: String,
        globals: Option<Vec<(String, PyArgument)>>,
        locals: Option<Vec<(String, PyArgument)>>,
        imports: Vec<String>,
    ) -> anyhow::Result<String> {
        Python::attach(|py| {
            // 1. 构建 globals 字典 (如果存在)
            let globals_bound = if let Some(vars) = globals {
                let dict = PyDict::new(py);
                for (key, val) in vars {
                    dict.set_item(key, val.to_py_object(py)?)?;
                }
                Some(dict)
            } else {
                None
            };

            // 2. 构建 locals 字典 (如果存在)
            // 如果 user 没传 locals 但传了 imports 且没传 globals，为了让 import 生效，
            // 我们可能需要强制创建一个 locals，或者就把 import 放 globals 里。
            // 这里为了逻辑简单，尽量遵循 Python 原生行为，但在 import 处理上做一点智能判断。
            let mut locals_bound = if let Some(vars) = locals {
                let dict = PyDict::new(py);
                for (key, val) in vars {
                    dict.set_item(key, val.to_py_object(py)?)?;
                }
                Some(dict)
            } else {
                None
            };

            // 3. 处理 Imports (自动注入)
            // 优先级规则：
            // A. 如果有自定义 globals，注入到 globals
            // B. 如果有自定义 locals，注入到 locals
            // C. 如果都没自定义 (都是 None)，为了让 import 生效，我们必须创建一个 locals 来承载 import
            if !imports.is_empty() {
                let target_dict = if let Some(ref g) = globals_bound {
                    Some(g)
                } else if let Some(ref l) = locals_bound {
                    Some(l)
                } else {
                    // C 情况：创建临时 locals
                    locals_bound = Some(PyDict::new(py));
                    locals_bound.as_ref()
                };

                if let Some(dict) = target_dict {
                    for module_name in imports {
                        let module = PyModule::import(py, &module_name)?;
                        dict.set_item(module_name, module)?;
                    }
                }
            }

            // 4. 执行 eval
            // 注意：PyO3 期望的是 Option<&Bound>, 所以我们需要 as_ref()
            let result = py.eval(
                CString::new(code).unwrap().as_ref(),
                globals_bound.as_ref(),
                locals_bound.as_ref(),
            )?;

            Ok(result.to_string())
        })
    }

    /// 设置模块的属性
    /// 对应 Python: module.attr = value
    pub fn set_module_attr(
        module_name: String,
        attr_name: String,
        value: PyArgument,
    ) -> anyhow::Result<()> {
        Python::attach(|py| {
            let module = PyModule::import(py, &module_name)?;
            module.setattr(attr_name, value.to_py_object(py)?)?;
            Ok(())
        })
    }

    /// 执行 Python 代码片段（无返回值）
    /// 适用于 import, class 定义, def 函数定义等
    pub fn execute(
        code: String,
        globals: Option<Vec<(String, PyArgument)>>,
        locals: Option<Vec<(String, PyArgument)>>,
    ) -> anyhow::Result<()> {
        Python::attach(|py| {
            let globals_bound = prepare_dict(py, globals)?;
            let locals_bound = prepare_dict(py, locals)?;

            py.run(
                CString::new(code).unwrap().as_c_str(),
                globals_bound.as_ref(),
                locals_bound.as_ref(),
            )?;
            Ok(())
        })
    }

    /// 运行一个 Python 脚本文件
    pub fn run_file(file_path: String) -> anyhow::Result<()> {
        let code = fs::read_to_string(&file_path)
            .context(format!("Failed to read python file: {}", file_path))?;

        // 这里的 module_name 传 "main" 或文件名均可
        Python::attach(|py| {
            PyModule::from_code(
                py,
                CString::new(code).unwrap().as_ref(),
                CString::new(file_path.clone()).unwrap().as_c_str(),
                CString::new("main").unwrap().as_c_str(),
            )?;
            Ok(())
        })
    }

    /// 计算表达式并返回一个通用对象句柄 (PyObjectWrapper)
    /// 这允许 Dart 持有这个对象，并在随后调用它的方法
    pub fn eval_as_object(
        code: String,
        globals: Option<Vec<(String, PyArgument)>>,
        locals: Option<Vec<(String, PyArgument)>>,
    ) -> anyhow::Result<PyObjectWrapper> {
        Python::attach(|py| {
            let globals_bound = prepare_dict(py, globals)?;
            let locals_bound = prepare_dict(py, locals)?;

            let result = py.eval(
                CString::new(code).unwrap().as_c_str(),
                globals_bound.as_ref(),
                locals_bound.as_ref(),
            )?;

            // 将 Bound<'_, PyAny> 转换为持久化的 Py<PyAny>
            Ok(PyObjectWrapper {
                inner: result.into(),
            })
        })
    }
}

// 辅助函数：构建字典
fn prepare_dict(
    py: Python,
    vars: Option<Vec<(String, PyArgument)>>,
) -> anyhow::Result<Option<Bound<PyDict>>> {
    if let Some(vars) = vars {
        let dict = PyDict::new(py);
        for (key, val) in vars {
            dict.set_item(key, val.to_py_object(py)?)?;
        }
        Ok(Some(dict))
    } else {
        Ok(None)
    }
}

// 1. 定义一个枚举，用来接收 Dart 传来的不同类型的参数
#[derive(Debug, Clone)]
pub enum PyArgument {
    Str(String),
    Int(i64),
    Float(f64),
    Bool(bool),
    // 如果需要传递列表，可以递归定义，或者简单处理
    ListStr(Vec<String>),
    ListInt(Vec<i64>),
}

// 2. 为枚举实现一个方法，将其转换为 Python 对象
impl PyArgument {
    fn to_py_object(&self, py: Python) -> anyhow::Result<Py<PyAny>> {
        Ok(match self {
            PyArgument::Str(val) => val.into_py_any(py)?,
            PyArgument::Int(val) => val.into_py_any(py)?,
            PyArgument::Float(val) => val.into_py_any(py)?,
            PyArgument::Bool(val) => val.into_py_any(py)?,
            PyArgument::ListStr(val) => val.into_py_any(py)?,
            PyArgument::ListInt(val) => val.into_py_any(py)?,
        })
    }
}

// 1. 定义一个包装结构体，用来持有 Python 对象
// 默认情况下 FRB 会把它处理成 Opaque 类型（Dart 端只持有句柄）
pub struct PyModuleWrapper {
    // PyObject 是一个长期的引用，不依赖当前的 GIL
    inner: Py<PyAny>,
}

impl PyModuleWrapper {
    // 2. 提供给 Dart 调用的静态 import 方法
    // 返回 Result，这样如果 import 失败，Dart 端会捕获异常
    #[frb(sync)] // 可选：如果 import 很快，可以用 sync；否则去掉让它变成 Future
    pub fn import_module(module_name: String) -> anyhow::Result<PyModuleWrapper> {
        // 获取 GIL
        Python::attach(|py| {
            // 尝试导入模块
            let module = PyModule::import(py, &module_name)?;

            // 将 &PyModule 转换为 PyObject (持久化)
            let persistent_obj = module.into();

            // 返回包装好的结构体
            Ok(PyModuleWrapper {
                inner: persistent_obj,
            })
        })
    }

    // 3. 示例：调用模块里的函数
    // 比如 math.sqrt(16)
    // 这里的 args 可以根据需要改成具体的参数
    #[frb(sync)]
    pub fn call_function(&self, func_name: String) -> anyhow::Result<String> {
        Python::attach(|py| {
            // 获取内部对象在当前 GIL 下的引用
            let module = self.inner.as_any();

            // 调用模块下的函数 (这里演示无参数调用，或者你可以传参)
            let result = module.call_method0(py, &func_name)?;

            // 将结果转为 String 返回给 Dart
            Ok(result.to_string())
        })
    }

    // 4. 示例：获取模块的字符串表示
    #[frb(sync)]
    pub fn as_str(&self) -> String {
        Python::attach(|_| self.inner.as_ref().to_string())
    }

    // call_function 保持不变
    #[frb(sync)]
    pub fn call_function_args(
        &self,
        func_name: String,
        args: Vec<PyArgument>,
    ) -> anyhow::Result<String> {
        Python::attach(|py| {
            let module = self.inner.as_ref();
            let py_args_vec: Vec<Py<PyAny>> = args
                .iter()
                .map(|arg| arg.to_py_object(py).unwrap())
                .collect();
            let py_tuple = PyTuple::new(py, py_args_vec).unwrap();
            let result = module.call_method1(py, &func_name, py_tuple)?;

            Ok(result.to_string())
        })
    }
}

/// 手动初始化 Python 环境
/// 参数由 Dart 端传入，更加灵活
#[frb(sync)]
pub fn init_py_env(
    python_home: String,
    lib_path: String,
    site_packages: String,
) -> anyhow::Result<()> {
    unsafe {
        // 1. 设置 PYTHONHOME (基础路径)
        env::set_var("PYTHONHOME", &python_home);

        // 2. 拼接 PYTHONPATH (macOS/Linux 用冒号 : 分割，Windows 用分号 ;)
        // 只有设置了这个，Python 才能找到 os, sys.path 等标准库
        let full_python_path = format!("{}:{}", lib_path, site_packages);
        env::set_var("PYTHONPATH", &full_python_path);

        println!("Rust Init: HOME={}", python_home);
        println!("Rust Init: PATH={}", full_python_path);
    }

    // 3. 启动 Python (确保 Cargo.toml 里没有 "auto-initialize")
    Python::initialize();

    // 4. (可选) 立即验证环境是否健康
    Python::attach(|py| {
        let sys = py.import("sys")?;
        // 如果这里不报错，说明 sys.path 正常，os 模块也能正常加载
        let path = sys.getattr("path")?;
        println!("Rust Check: Python initialized successfully. sys.path exists.{path}");
        Ok(())
    })
}

#[frb(opaque)]
pub struct PyObjectWrapper {
    inner: Py<PyAny>,
}

impl PyObjectWrapper {
    // --- 基础转换与显示 ---

    /// 对应 Python: str(self)
    #[frb(sync)]
    pub fn as_str(&self) -> String {
        Python::attach(|py| self.inner.bind(py).str().unwrap().to_string())
    }

    /// 对应 Python: repr(self)
    #[frb(sync)]
    pub fn as_repr(&self) -> String {
        Python::attach(|py| self.inner.bind(py).repr().unwrap().to_string())
    }

    /// 尝试转换成 i64
    #[frb(sync)]
    pub fn as_int(&self) -> anyhow::Result<i64> {
        Python::attach(|py| {
            self.inner
                .extract(py)
                .map_err(|e| anyhow::anyhow!("Not an int: {}", e))
        })
    }

    /// 尝试转换成 f64
    #[frb(sync)]
    pub fn as_float(&self) -> anyhow::Result<f64> {
        Python::attach(|py| {
            self.inner
                .extract(py)
                .map_err(|e| anyhow::anyhow!("Not a float: {}", e))
        })
    }

    /// 尝试转换成 bool
    #[frb(sync)]
    pub fn as_bool(&self) -> anyhow::Result<bool> {
        Python::attach(|py| {
            self.inner
                .extract(py)
                .map_err(|e| anyhow::anyhow!("Not a bool: {}", e))
        })
    }

    /// 尝试将 List 转换为 Vec<String> (用于 Dart)
    pub fn as_list_string(&self) -> anyhow::Result<Vec<String>> {
        Python::attach(|py| {
            self.inner
                .extract(py)
                .map_err(|e| anyhow::anyhow!("Not a list of strings: {}", e))
        })
    }

    // --- 属性操作 (PyAnyMethods::getattr/setattr) ---

    /// 获取属性，返回新的对象句柄
    /// Python: self.attr_name
    #[frb(sync)]
    pub fn getattr(&self, attr_name: String) -> anyhow::Result<PyObjectWrapper> {
        Python::attach(|py| {
            let obj = self.inner.bind(py);
            let attr = obj.getattr(&attr_name)?;
            Ok(PyObjectWrapper { inner: attr.into() })
        })
    }

    /// 设置属性
    /// Python: self.attr_name = value
    #[frb(sync)]
    pub fn setattr(&self, attr_name: String, value: PyArgument) -> anyhow::Result<()> {
        Python::attach(|py| {
            let obj = self.inner.bind(py);
            obj.setattr(attr_name, value.to_py_object(py)?)?;
            Ok(())
        })
    }

    /// 检查属性是否存在
    /// Python: hasattr(self, attr_name)
    #[frb(sync)]
    pub fn hasattr(&self, attr_name: String) -> anyhow::Result<bool> {
        Python::attach(|py| {
            let obj = self.inner.bind(py);
            Ok(obj.hasattr(attr_name)?)
        })
    }

    // --- 调用 (PyAnyMethods::call) ---

    /// 调用对象 (如果它是函数或类)
    /// Python: self(*args)
    pub fn call(&self, args: Vec<PyArgument>) -> anyhow::Result<PyObjectWrapper> {
        Python::attach(|py| {
            let obj = self.inner.bind(py);

            // 构建 args tuple
            let py_args: Vec<Py<PyAny>> = args
                .iter()
                .map(|arg| arg.to_py_object(py).unwrap())
                .collect();
            let args_tuple = PyTuple::new(py, py_args)?;

            let result = obj.call1(args_tuple)?;
            Ok(PyObjectWrapper {
                inner: result.into(),
            })
        })
    }

    /// 调用对象的方法
    /// Python: self.method_name(*args)
    pub fn call_method(
        &self,
        method_name: String,
        args: Vec<PyArgument>,
    ) -> anyhow::Result<PyObjectWrapper> {
        Python::attach(|py| {
            let obj = self.inner.bind(py);

            let py_args: Vec<Py<PyAny>> = args
                .iter()
                .map(|arg| arg.to_py_object(py).unwrap())
                .collect();
            let args_tuple = PyTuple::new(py, py_args)?;

            let result = obj.call_method1(&method_name, args_tuple)?;
            Ok(PyObjectWrapper {
                inner: result.into(),
            })
        })
    }

    // --- 集合/序列操作 (PyAnyMethods::len, contains, get_item) ---

    /// 获取长度 (用于 List, Dict, Str, Set 等)
    /// Python: len(self)
    #[frb(sync)]
    pub fn len(&self) -> anyhow::Result<usize> {
        Python::attach(|py| {
            let obj = self.inner.bind(py);
            Ok(obj.len()?)
        })
    }

    /// 检查是否为空
    #[frb(sync)]
    pub fn is_empty(&self) -> anyhow::Result<bool> {
        Python::attach(|py| {
            // PyAnyMethods::is_empty 是 0.21+ 的特性，或者手动 len() == 0
            // 这里我们手动实现兼容性更好
            let obj = self.inner.bind(py);
            let len = obj.len()?;
            Ok(len == 0)
        })
    }

    /// 字典/列表获取项
    /// Python: self[key]
    #[frb(sync)]
    pub fn get_item(&self, key: PyArgument) -> anyhow::Result<PyObjectWrapper> {
        Python::attach(|py| {
            let obj = self.inner.bind(py);
            let key_obj = key.to_py_object(py)?;
            let item = obj.get_item(key_obj)?;
            Ok(PyObjectWrapper { inner: item.into() })
        })
    }

    /// 字典/列表设置项
    /// Python: self[key] = value
    #[frb(sync)]
    pub fn set_item(&self, key: PyArgument, value: PyArgument) -> anyhow::Result<()> {
        Python::attach(|py| {
            let obj = self.inner.bind(py);
            let key_obj = key.to_py_object(py)?;
            let val_obj = value.to_py_object(py)?;
            obj.set_item(key_obj, val_obj)?;
            Ok(())
        })
    }

    // --- 类型检查 ---

    #[frb(sync)]
    pub fn is_none(&self) -> bool {
        Python::attach(|py| self.inner.bind(py).is_none())
    }

    #[frb(sync)]
    pub fn is_callable(&self) -> bool {
        Python::attach(|py| self.inner.bind(py).is_callable())
    }
}
