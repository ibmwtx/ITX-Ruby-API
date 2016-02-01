
load 'general.rb'
load 'properties.rb'
load 'map.rb'
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
rc = Map.mpiMapLoadFile(hMap, "test4.mmc")
check_err(rc)

hMap = hMap.get_pointer(0)

rc = Map.mpiMapRegisterStatusMethod(hMap.address, Map::MPICTRLMTDC, MPI_EVENT_ALL)
check_err(rc)

rc = Map.mpiMapRun(hMap.address)
check_err(rc)

szMsg = FFI::MemoryPointer.new :pointer
tlen = FFI::MemoryPointer.new(:size_t, 1)
rc = Properties.mpiPropertyGetText(hMap.address, MPIP_OBJECT_ERROR_MSG, 0, szMsg, tlen)
check_err(rc)

szMsgPtr = szMsg.read_pointer()

iRC = FFI::MemoryPointer.new(:int, 1)
rc = Properties.mpiPropertyGetInteger(hMap.address, MPIP_OBJECT_ERROR_CODE, 0, iRC)
check_err(rc)

puts "Map status: " + szMsgPtr.read_string + " (" + iRC.get_int(0).to_s + ")"

rc = Map.mpiMapUnload(hMap.address)
check_err(rc)

rc = General.mpiTermAPI()
check_err(rc)