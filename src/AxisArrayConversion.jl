module AxisArrayConversion
using Requires
export to

const PUBLIC = "This function is part of the public API and subject to SemVer guarantees."
const PRIVATE = "This function is considered private and may silently change or be removed."
"""
    namedtuple(arr)::NamedTuple{(:axes, :values)}

Create a `NamedTuple` from an array `arr` with axis data.

$PUBLIC
"""
function namedtuple end

"""
    from_namedtuple(::Type{T}, nt::NamedTuple)

Construct an instance of `T` from a `NamedTuple` `nt` with propertynames `(:axes, :values)`.

$PUBLIC
"""
function from_namedtuple(::Type{T}, nt::NamedTuple)::T where {T <:NamedTuple}
    return nt::T
end

"""
    to(SomeArray, ::OtherArray)::SomeArray

Construct an instance of `SomeArray` from an instance of `OtherArray`.

This function should not be overloaded. Instead [`namedtuple`](@ref) and [`from_namedtuple`](@ref) should be overloaded.

$PUBLIC
"""
function to(::Type{T}, o) where {T}
    nt = namedtuple(o)
    return from_namedtuple(T,nt)::T
end

"""
    roottype(::Type{T})

Construct a more general variant of an AxisArray like type `T`. Typically by stripping all type parameters.
```jldoctest
julia> using AxisArrayConversion: roottype

julia> roottype(Vector{Int})
Array

julia> roottype(typeof((a=1, b=2)))
NamedTuple
```
$PUBLIC
"""
roottype(::Type{T}) where {T <: NamedTuple} = NamedTuple

ntfieldnames(::Type{<:NamedTuple{fnames}}) where {fnames} = fnames

function check_consistency(arr::AbstractArray)
end

"""
    check_consistency(axis_array_like)

Check that a `NamedTuple` represents an axis array like object.
Also accepts `AbstractArray` inputs, which means a noop.

# Examples
```jldoctest
julia> using AxisArrayConversion: check_consistency

julia> check_consistency((axs=(1:2,), values=[1,2]))
ERROR: ArgumentError: Unexpected properties.
Expected exactly two properties `axes`, `values`
Got: `propertynames(nt) = (:axs, :values)
[...]


julia> check_consistency((axes=(1:2,), values=[1 2; 3 4]))
ERROR: ArgumentError: Inconsistent number of dimensions.
Expected: length(nt.axes) == ndims(nt.values)
Got: length(nt.axes)  = 1
ndims(nt.values) = 2
[...]

julia> check_consistency((axes=(1:2,), values=[1,2,3]))
ERROR: ArgumentError: Inconsistent size.
Expected: map(length, Tuple(nt.axes)) == size(nt.values)
Got: map(length, Tuple(nt.axes)) = (2,)
Got: size(nt.values) = (3,)
[...]

julia> check_consistency((axes=(1:2,), values=[1,2])) # works

julia> check_consistency([1,2,3]) # noop for AbstractArray
```
$PUBLIC
"""
function check_consistency(nt::NamedTuple)
    pnames = ntfieldnames(typeof(nt))
    if (length(nt) !== 2) || !(:axes in pnames) || !(:values in pnames)
        msg = """
        Unexpected properties.
        Expected exactly two properties `axes`, `values`
        Got: `propertynames(nt) = $pnames"""
        throw(ArgumentError(msg))
    end
    ax_ndims = length(nt.axes)
    vals_ndims = ndims(nt.values)
    if ax_ndims != vals_ndims
        msg = """
        Inconsistent number of dimensions.
        Expected: length(nt.axes) == ndims(nt.values)
        Got: length(nt.axes)  = $(ax_ndims)
        ndims(nt.values) = $(vals_ndims)"""
        throw(ArgumentError(msg))
    end
    ax_size = map(length, Tuple(nt.axes))
    vals_size = size(nt.values)
    if ax_size != vals_size
        msg = """
        Inconsistent size.
        Expected: map(length, Tuple(nt.axes)) == size(nt.values)
        Got: map(length, Tuple(nt.axes)) = $ax_size
        Got: size(nt.values) = $vals_size"""
        throw(ArgumentError(msg))
    end
end
################################################################################
##### Helpers
################################################################################

@inline function axissymbol_from_Int(i::Int)
    return Symbol("x$i")
end

function axissymbols(arr::AbstractArray{T, dim}) where {T,dim}
    make_axissymbols(Val(dim))
end

"""

    make_axissymbols(::Val{dim})::NTuple{dim, Symbol}

Create default names for `dim` many axes.

$PRIVATE
"""
@generated function make_axissymbols(::Val{dim}) where {dim}
    ntuple(axissymbol_from_Int, dim)
end

"""
    name_axes(axes)::NamedTuple

Add names to `axes` or return them as is, if they already have names.
```jldoctest
julia> using AxisArrayConversion: name_axes

julia> name_axes((1:3, ["a", "b"]))
(x1 = 1:3, x2 = ["a", "b"])

julia> name_axes((a=1:3, b=["a", "b"]))
(a = 1:3, b = ["a", "b"])
```

$PUBLIC
"""
function name_axes(axes::NamedTuple)
    return axes
end

function name_axes(axes::NTuple{N, Any}) where {N}
    names = make_axissymbols(Val(N))
    return NamedTuple{names}(axes)
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
    return name_axes(o.axes)
end
function values(o::NamedTuple)
    return o.values
end
function namedtuple(o)
    return (axes=namedaxes(o), values=values(o))
end

function __init__()
    @require AxisArrays = "39de3d68-74b9-583c-8d2d-e117c070f3a9" include("AxisArrays.jl")
    @require AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"   include("AxisKeys.jl")
    @require DimensionalData = "0703355e-b756-11e9-17c0-8b28908087d0" include("DimensionalData.jl")

end

include("Base.jl")

end
