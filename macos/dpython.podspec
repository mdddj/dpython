#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint test_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
    s.name             = 'dpython'
    s.version          = '0.0.1'
    s.summary          = 'A new Flutter FFI plugin project.'
    s.description      = <<-DESC
    A new Flutter FFI plugin project.
    DESC
    s.homepage         = 'http://example.com'
    s.license          = { :file => '../LICENSE' }
    s.author           = { 'Your Company' => 'email@example.com' }
    s.source           = { :path => '.' }
    s.source_files     = 'Classes/**/*'
    # s.dependency 'FlutterMacOS'
    # s.platform = :osx, '10.11'
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
    s.swift_version = '5.0'
    s.script_phase = {
      :name => 'Build Rust library',
      :script => 'sh "$PODS_TARGET_SRCROOT/../cargokit/build_pod.sh" ../rust dpython',
      :execution_position => :before_compile,
      :input_files => ['${BUILT_PRODUCTS_DIR}/cargokit_phony'],
      # Let XCode know that the static library referenced in -force_load below is
      # created by this build step.
      :output_files => ["${BUILT_PRODUCTS_DIR}/libdpython.a"],
    }

    # --- 🟢 新增：动态获取 Python 配置逻辑 ---
    # 定义你需要的 Python 版本
    py_version = "3.14"
    config_cmd = "python#{py_version}-config"

    # 在 Shell 中执行命令，获取链接参数
    # --ldflags: 获取链接标志 (-L... -l...)
    # --embed:   这是 Python 3.8+ 必须的，用于嵌入解释器
    # .strip:    去掉末尾的换行符
    # 2>/dev/null: 忽略错误信息（如果没安装）
    
    # 1. 尝试执行 python3.14-config
    python_ldflags = `#{config_cmd} --ldflags --embed 2>/dev/null`.strip

    # 2. 如果没找到输出，给个警告，或者尝试回退到默认的 python3-config
    if python_ldflags.empty?
      puts "\n\n[dpython] ⚠️  WARNING: command '#{config_cmd}' failed or empty."
      puts "[dpython] Trying 'python3-config'..."
      python_ldflags = `python3-config --ldflags --embed 2>/dev/null`.strip
    end

    # 3. 如果还是空，打印严重错误提示（但为了不打断 pod install，这里不 raise error）
    if python_ldflags.empty?
       puts "[dpython] ❌ ERROR: Could not find python config. Linking might fail.\n\n"
    else
       puts "\n[dpython] ✅ Found Python flags: #{python_ldflags}\n"
    end
    # --- 🟢 结束 ---

    s.pod_target_xcconfig = {
      'DEFINES_MODULE' => 'YES',
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
      'OTHER_LDFLAGS' => "-force_load ${BUILT_PRODUCTS_DIR}/libdpython.a #{python_ldflags}",
      'LIBRARY_SEARCH_PATHS' => '$(inherited) /usr/local/lib /opt/homebrew/lib /opt/homebrew/lib '
    }
  end