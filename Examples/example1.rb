
 
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
rc = Map.mpiMapLoadFile(hMap, "test1.mmc")

check_err(rc)

hMap = hMap.get_pointer(0)

rc = Map.mpiMapRun(hMap.address)

szMsg = FFI::MemoryPointer.new(:pointer,1)
zero = FFI::MemoryPointer.new(:int, 1)
rc = Properties.mpiPropertyGetText(hMap.address, MPIP_OBJECT_ERROR_MSG, 0, szMsg, zero)
szMsgPtr = szMsg.read_pointer()
iRC = FFI::MemoryPointer.new(:int, 1)
rc = Properties.mpiPropertyGetInteger(hMap.address, MPIP_OBJECT_ERROR_CODE, 0, iRC)

puts "Map status: " + szMsgPtr.read_string() + " (" + iRC.get_int(0).to_s + ")"

rc = Map.mpiMapUnload(hMap.address)
check_err(rc);

#rc = General.mpiTermAPI()
check_err(rc)

