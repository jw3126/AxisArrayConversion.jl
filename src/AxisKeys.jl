import AxisKeys
const AK = AxisKeys

keyedarray(o) = to(AK.KeyedArray, o)

function from_namedtuple(::Type{T}, nt::NamedTuple) where {T<:AK.KeyedArray}
    AK.KeyedArray(nt.values; nt.axes...)::T
end

namedaxes(ak::AK.KeyedArray) = AK.named_axiskeys(ak)
values(ak::AK.KeyedArray) = parent(parent(ak))

