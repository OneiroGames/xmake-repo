package("slang")
    set_homepage("https://github.com/shader-slang/slang")
    set_description("A portable, flexible file i/o abstraction.")
    set_license("zlib")

    add_urls("https://github.com/shader-slang/slang/archive/$(version).tar.gz",
             "https://github.com/shader-slang/slang.git")

    -- TODO: Add configs

    add_deps("cmake")

    on_install("macosx", "windows", "linux", "mingw", function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        table.insert(configs, "-DSLANG_ENABLE_GFX=OFF")
        table.insert(configs, "-DSLANG_ENABLE_EXAMPLES=OFF")
        table.insert(configs, "-DSLANG_ENABLE_TESTS=OFF")
        table.insert(configs, "-DSLANG_ENABLE_SLANG_GLSLANG=OFF")
        table.insert(configs, "-DSLANG_ENABLE_SLANGC=OFF")
        table.insert(configs, "-DSLANG_ENABLE_SLANGD=OFF")
        import("package.tools.cmake").install(package, configs)
    end)
