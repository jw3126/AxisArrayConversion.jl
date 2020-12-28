import AxisKeys
const AK = AxisKeys

function keyedarray(nt::NamedTuple)
    AK.KeyedArray(nt.values; nt.axes...)
end

namedaxes(ak::AK.KeyedArray) = AK.named_axiskeys(ak)
values(ak::AK.KeyedArray) = parent(parent(ak))
