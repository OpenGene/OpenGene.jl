
import DataStructures:OrderedDict

typealias GtfHeader OrderedDict{ASCIIString, ASCIIString}

type Gtf
    header::GtfHeader
    data::DataFrame
end