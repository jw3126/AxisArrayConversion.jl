using AxisArrayConversion
using Documenter

makedocs(;
    modules=[AxisArrayConversion],
    authors="Jan Weidner <jw3126@gmail.com> and contributors",
    repo="https://github.com/jw3126/AxisArrayConversion.jl/blob/{commit}{path}#L{line}",
    sitename="AxisArrayConversion.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jw3126.github.io/AxisArrayConversion.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jw3126/AxisArrayConversion.jl",
)
