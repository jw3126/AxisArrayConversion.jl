import .DimensionalData
const DD = DimensionalData

axissymbol(::DD.Dim{s}) where {s} = s
axissymbols(o::DD.DimensionalArray) = map(axissymbol, DD.dims(o))
axisvalues(o::DD.DimensionalArray) = DD.val(o)
values(o::DD.DimensionalArray) = parent(o)

function from_namedtuple(::Type{T}, nt::NamedTuple) where {T <: DD.DimensionalArray}
    return DD.DimArray(nt.values, nt.axes)::T
end

roottype(::Type{T}) where {T<:DD.DimensionalArray} = DD.DimensionalArray
