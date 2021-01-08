import .AxisArrays
const AA = AxisArrays

axissymbol(ax::AA.Axis{s}) where {s} = s

axissymbols(aa::AA.AxisArray) = map(axissymbol, AA.axes(aa))
axisvalues(aa::AA.AxisArray) = AA.axisvalues(aa)
values(aa::AA.AxisArray) = parent(aa)

function from_namedtuple(::Type{T}, nt::NamedTuple) where {T<:AA.AxisArray}
    return AA.AxisArray(nt.values; nt.axes...)::T
end
