module AxisArrayConversion
using Requires
export to

"""
    namedtuple(arr)::NamedTuple{(:axes, :values)}

Create a `NamedTuple` from an array `arr` with axis data.
"""
function namedtuple end

"""
    from_namedtuple(::Type{T}, nt::NamedTuple)

Construct an instance of `T` from a `NamedTuple` `nt` with propertynames `(:axes, :values)`.
"""
function from_namedtuple(::Type{T}, nt::NamedTuple)::T where {T <:NamedTuple}
    return nt::T
end

"""
    to(SomeArray, ::OtherArray)::SomeArray

Construct an instance of `SomeArray` from an instance of `OtherArray`.

This function should not be overloaded. Instead [`namedtuple`](@ref) and [`from_namedtuple`](@ref) should be overloaded.
"""
function to(::Type{T}, o) where {T}
    nt = namedtuple(o)
    return from_namedtuple(T,nt)::T
end

################################################################################
##### Helpers
################################################################################

@inline function axissymbol_from_Int(i::Int)
    return Symbol("x$i")
end

@generated function axissymbols(arr::AbstractArray{T, dim}) where {T,dim}
    ntuple(axissymbol_from_Int, dim)
end

function axisvalues(arr::AbstractArray)
    Base.axes(arr)
end

function values(arr::AbstractArray)
    arr
end

function namedaxes(o)
    return NamedTuple{axissymbols(o)}(axisvalues(o))
end
function namedaxes(o::NamedTuple)
    return o.axes
end
function values(o::NamedTuple)
    return o.values
end
function namedtuple(o)
    return (axes=namedaxes(o), values=values(o))
end

function _collect(::Type{T}, arr::Array{T}) where {T}
    arr
end
function _collect(::Type{T}, arr::AbstractArray) where {T}
    collect(T, arr)
end
_collect(arr::Array) = arr
_collect(arr) = collect(arr)


function from_namedtuple(Arr::Type{<: Array{T}}, nt::NamedTuple) where {T}
    _collect(T, nt.values)::Arr
end

function from_namedtuple(Arr::Type{<: Array}, nt::NamedTuple)
    _collect(nt.values)::Arr
end

function __init__()
    @require AxisArrays = "39de3d68-74b9-583c-8d2d-e117c070f3a9" include("AxisArrays.jl")
    @require AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"   include("AxisKeys.jl")
    @require DimensionalData = "0703355e-b756-11e9-17c0-8b28908087d0" include("DimensionalData.jl")

end

end
