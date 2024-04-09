package("vuk")
    set_homepage("https://github.com/martty/vuk")
    set_description("A rendergraph-based abstraction for Vulkan")
    set_license("MIT")

    add_urls("https://github.com/martty/vuk/archive/$(version).tar.gz",
             "https://github.com/martty/vuk.git")

    -- TODO: Add configs

    on_install("macosx", "windows", "linux", "mingw", function (package)
        for _, file in ipairs(os.files("include/vuk/*.hpp")) do
            io.replace(file, "../src/", "")
        end
        io.replace("src/Program.cpp", "#include <spirv_cross.hpp>", "#include <spirv_cross/spirv_cross.hpp>")
        io.replace("src/Context.cpp", "#if VUK_USE_SHADERC", "#include <locale>\n#if VUK_USE_SHADERC\n")
        os.cp("src/CreateInfo.hpp", "include/vuk/")
        
        local xmake_lua = [[
            add_rules("mode.debug", "mode.release")
            add_requires("plf_colony", "robin-hood-hashing", "fmt", "concurrentqueue", "vulkan-memory-allocator", "vulkansdk", "spirv-cross")
            target("vuk")
                set_languages("c++20")
                set_kind("static")
                add_includedirs("include/", {public = true})
                add_headerfiles("include/vuk/*.hpp")
                add_files("src/*.cpp")
                add_defines("VUK_USE_SHADERC=0", "VUK_USE_DXC=0")
                add_defines("NOMINMAX", "VC_EXTRALEAN", "WIN32_LEAN_AND_MEAN", "_CRT_SECURE_NO_WARNINGS", "_SCL_SECURE_NO_WARNINGS", "_SILENCE_CLANG_CONCEPTS_MESSAGE", "_SILENCE_CXX23_ALIGNED_STORAGE_DEPRECATION_WARNING", "DOCTEST_CONFIG_DISABLE", {public = true})
                add_packages("plf_colony", "robin-hood-hashing", "fmt", "concurrentqueue", "vulkan-memory-allocator", "vulkansdk", "spirv-cross", {public = true})
            after_build(function (target)
                if (is_plat("windows")) then
                    for _, pkg in ipairs(target:orderpkgs()) do 
                        for _, dllpath in ipairs(table.wrap(pkg:get("libfiles"))) do
                            if dllpath:endswith(".dll") then
                                os.vcp(dllpath, target:targetdir()) 
                            end 
                        end
                    end
                end
            end)
        ]]
        io.writefile("xmake.lua", xmake_lua)
        import("package.tools.xmake").install(package)
        
        os.cp("include", package:installdir())
        os.cp("src/CreateInfo.hpp", package:installdir() .. "/include/vuk/")
    end)
