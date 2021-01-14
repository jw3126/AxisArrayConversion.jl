# AxisArrayConversion

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jw3126.github.io/AxisArrayConversion.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jw3126.github.io/AxisArrayConversion.jl/dev)
[![Build Status](https://github.com/jw3126/AxisArrayConversion.jl/workflows/CI/badge.svg)](https://github.com/jw3126/AxisArrayConversion.jl/actions)
[![Coverage](https://codecov.io/gh/jw3126/AxisArrayConversion.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jw3126/AxisArrayConversion.jl)

# AxisArrayConversion

[AxisArrayConversion.jl](https://github.com/jw3126/AxisArrayConversion.jl) allows converting between [AxisArrays.jl](https://github.com/JuliaArrays/AxisArrays.jl) like packages.
* [AxisArrays.AxisArray](https://github.com/JuliaArrays/AxisArrays.jl)
* [AxisKeys.KeyedArray](https://github.com/mcabbott/AxisKeys.jl)
* [DimensionalData.DimArray](https://github.com/rafaqz/DimensionalData.jl)
* [AxisArrayConversion.SimpleAxisArray](https://github.com/jw3126/AxisArrayConversion.jl)
* Base.NamedTuple

# Supporting more arrays

Conversions between two array types is provided by using the path
```julia
MyArray -> NamedTuple -> OtherArray
```
This has multiple advantages:
* For `N` array types, only `2N` methods must be implemented.
* Conversion can be implemented between packages that don't know about each other.

In order to support `MyArray`, the following must be implemented:

```julia
function AxisArrayConversion.namedtuple(arr::MyArray)
    ...
    return (axes=..., values=...)
end

function AxisArrayConversion.from_namedtuple(::Type{MyArray}, nt::NamedTuple)
    ... = nt.axes
    ... = nt.values
    return MyArray(...)
end
```

And now any fancy conversion should work
```julia
using MyArrays, OtherArrays
using AxisArrayConversion: to
using Test

ma = MyArrays(...)
oa = to(OtherArray, ma)
@test oa isa OtherArrays.OtherArray
@test ma == to(MyArray, oa)
```
