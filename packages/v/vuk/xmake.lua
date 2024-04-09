package("vuk")
    set_homepage("https://github.com/martty/vuk")
    set_description("A rendergraph-based abstraction for Vulkan")
    set_license("MIT")

    add_urls("https://github.com/martty/vuk/archive/$(version).tar.gz",
             "https://github.com/martty/vuk.git")

    -- TODO: Add configs

    add_deps("cmake")

    on_install("macosx", "windows", "linux", "mingw", function (package)
        for _, file in ipairs(os.files("include/vuk/*.hpp")) do
            io.replace(file, "../src/", "")
        end
        os.cp("src/CreateInfo.hpp", "include/vuk/")
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        table.insert(configs, "-DVUK_USE_SHADERC =OFF")
        table.insert(configs, "-DVUK_USE_DXC=OFF")
        import("package.tools.cmake").install(package, configs, {buildir = "build"})
        os.cp("include", package:installdir())
        os.cp("build/Release/vuk.lib", package:installdir() .. "/lib/")
        os.cp("src/CreateInfo.hpp", package:installdir() .. "/include/vuk/")
    end)
