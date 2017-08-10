if isdefined(Base, :ASCIIString)==false && isdefined(Base, :String)
	const ASCIIString = String
end