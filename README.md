# AxisArrayConversion

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jw3126.github.io/AxisArrayConversion.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jw3126.github.io/AxisArrayConversion.jl/dev)
[![Build Status](https://github.com/jw3126/AxisArrayConversion.jl/workflows/CI/badge.svg)](https://github.com/jw3126/AxisArrayConversion.jl/actions)
[![Coverage](https://codecov.io/gh/jw3126/AxisArrayConversion.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jw3126/AxisArrayConversion.jl)

# AxisArrayConversion

[AxisArrayConversion.jl](https://github.com/jw3126/AxisArrayConversion.jl) allows converting between [AxisArrays.jl](https://github.com/JuliaArrays/AxisArrays.jl) like packages.
Currently it supports the following formats:
* [AxisArrays.AxisArray](https://github.com/JuliaArrays/AxisArrays.jl)
* [AxisKeys.KeyedArray](https://github.com/mcabbott/AxisKeys.jl)
* [DimensionalData.DimArray](https://github.com/rafaqz/DimensionalData.jl)
* Base.NamedTuple


# Supporting more arrays

Conversions between two array types provided by using the path
```julia
MyArray -> NamedTuple -> OtherArray
```
This has the advantages, that for `N` array types, only `2N` methods must be implemented
and also conversion can be implemented between packages that don't know about each other.

In order to support `MyArray`, the following must be implemented:

```julia
function AxisArrayConversion.namedtuple(arr::MyArray)
    ...
    return (axes=..., values=...)
end

function myarray(nt::NamedTuple)
    ... = nt.axes
    ... = nt.values
    return MyArray(...)
end
```

And now any fancy conversion should work
```julia
using MyArrays, OtherArrays
using Test

ma = MyArrays(...)
oa = otherarray(ma)
@test oa isa OtherArrays.OtherArray
@test ma == myarray(oa)
```
