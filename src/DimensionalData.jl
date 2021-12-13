import .DimensionalData
const DD = DimensionalData

axissymbol(::DD.Dim{s}) where {s} = s
axissymbols(o::DD.AbstractDimArray) = map(axissymbol, DD.dims(o))
axisvalues(o::DD.AbstractDimArray) = map(DD.val, DD.val(o))
values(o::DD.AbstractDimArray) = parent(o)

function from_namedtuple(::Type{T}, nt::NamedTuple) where {T <: DD.AbstractDimArray}
    return DD.DimArray(nt.values, nt.axes)::T
end

roottype(::Type{T}) where {T<:DD.AbstractDimArray} = DD.AbstractDimArray
