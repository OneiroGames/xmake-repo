package("slang")
    set_homepage("https://github.com/shader-slang/slang")
    set_description("Making it easier to work with shaders.")
    set_license("MIT")

    add_urls("https://github.com/shader-slang/slang/archive/$(version).tar.gz",
             "https://github.com/shader-slang/slang.git")

    -- TODO: Add configs

    add_deps("cmake", "miniz")
    on_install("macosx", "windows", "linux", "mingw", function (package)
        print(package:sourcehash())
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        table.insert(configs, "-DSLANG_ENABLE_GFX=OFF")
        table.insert(configs, "-DSLANG_ENABLE_EXAMPLES=OFF")
        table.insert(configs, "-DSLANG_ENABLE_TESTS=OFF")
        table.insert(configs, "-DSLANG_ENABLE_SLANG_GLSLANG=OFF")
        table.insert(configs, "-DSLANG_ENABLE_SLANGC=OFF")
        table.insert(configs, "-DSLANG_ENABLE_SLANGD=OFF")
        table.insert(configs, "-DSLANG_SLANG_LLVM_FLAVOR=DISABLE")
        import("package.tools.cmake").install(package, configs)
    end)
