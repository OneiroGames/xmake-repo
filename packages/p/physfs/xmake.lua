package("physfs")
    set_homepage("https://icculus.org/physfs/")
    set_description("A portable, flexible file i/o abstraction.")
    set_license("zlib")

    add_urls("https://github.com/icculus/physfs/archive/$(version).tar.gz",
             "https://github.com/icculus/physfs.git")

    -- TODO: Add configs

    add_deps("cmake")

    on_install("macosx", "windows", "linux", "mingw", function (package)
        io.writefile("xmake.lua", [[ 
            target("physfs")
                set_kind("static")
                set_languages("c++11")
                add_headerfiles("./src/*.h")
                add_includedirs("./src/")
                add_files("./src/*.cpp")
        ]])
        import("package.tools.xmake").install(package)
    end)
