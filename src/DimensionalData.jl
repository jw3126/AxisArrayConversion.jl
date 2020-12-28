import DimensionalData
const DD = DimensionalData

axissymbol(::DD.Dim{s}) where {s} = s
axissymbols(o::DD.DimensionalArray) = map(axissymbol, DD.dims(o))
axisvalues(o::DD.DimensionalArray) = DD.val(o)
values(o::DD.DimensionalArray) = parent(o)

function dimarray(nt::NamedTuple)
    DD.DimensionalArray(nt.values, nt.axes)
end
