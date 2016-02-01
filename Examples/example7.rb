
 
load 'general.rb'
load 'properties.rb'
load 'map.rb'
load 'card.rb'
load 'dtxdefs.rb'

def check_err(rc)
	if ((rc) <= MPIRC_TYPE_ERROR)
		puts "Last error is: " + General.mpiErrorGetText(rc)
		exit 0
	end
end

rc = General.mpiInitAPI(nil)
check_err(rc)

hMap = FFI::MemoryPointer.new :pointer
rc = Map.mpiMapLoadFile(hMap, "test7.mmc")
check_err(rc)

hMapPtr = hMap.get_pointer(0).address

# Get the adapter object handle for input card #1
hCard = FFI::MemoryPointer.new :pointer
rc = Map.mpiMapGetInputCardObject(hMapPtr, 1, hCard)
check_err(rc)

hCardPtr = hCard.get_pointer(0).address

# Get the handle to the adapter object
hAdapter = FFI::MemoryPointer.new :pointer
rc = Card.mpiCardGetAdapterObject(hCardPtr, hAdapter)
check_err(rc)

hAdapterPtr = hAdapter.get_pointer(0).address

# Get the adapter command line in raw format
szCommandLine = FFI::MemoryPointer.new :pointer
iLen = FFI::MemoryPointer.new(:size_t, 1)
rc = Properties.mpiPropertyGetText(hAdapterPtr, MPIP_ADAPTER_COMMANDLINE, 0, szCommandLine, iLen)
check_err(rc)

szCommandLinePtr = szCommandLine.read_pointer()

puts "The adapter command line is....\n" + szCommandLinePtr.read_string + "\n\n"

# Get it in XML format
MAX_BUFFER_LEN = 131072
szOutXML = FFI::MemoryPointer.new(:char, MAX_BUFFER_LEN)
iLen.put_int(0, szOutXML.size)
ids = FFI::MemoryPointer.new(:int, 1)
ids.put_int(0, MPIP_ADAPTER_COMMANDLINE)
rc = Properties.mpiPropertyGetPropertiesXML(hAdapterPtr, ids, 0, 1, szOutXML.slice(0, 1), iLen)
check_err(rc)

szOutXMLPtr = szOutXML.read_pointer()

puts "The adapter command line in XML is....\n"

for i in 0..MAX_BUFFER_LEN
	if (szOutXML.get_char(i) == 0)
		break
	end
	print szOutXML.get_char(i).chr
end

puts "\n"

# Modify the command line using XML

xml = "<Adapter><CommandLine id=\"" + MPIP_ADAPTER_COMMANDLINE.to_s
xml = xml + "\" type=\"text\">input2.txt</CommandLine></Adapter>"

szOutXML = FFI::MemoryPointer.from_string(xml)

rc = Properties.mpiPropertySetPropertiesXML(hAdapterPtr, szOutXML.read_string)
check_err(rc)

# Print all of the Adapter's properties in XML format
szOutXML = FFI::MemoryPointer.new(:char, iLen.get_int(0))
rc = Properties.mpiPropertyGetAllPropertiesXML(hAdapterPtr, szOutXML.slice(0,1), iLen, 0)
check_err(rc)

puts "The modified complete set of adapter properties is....\n"

for i in 0..MAX_BUFFER_LEN
	if (szOutXML.get_char(i) == 0)
		break
	end
	print szOutXML.get_char(i).chr
end

puts "\n"

# Clean up
rc = Map.mpiMapUnload(hMapPtr)
check_err(rc)

rc = General.mpiTermAPI()
check_err(rc)