
/* 
 * Copyright (C) 2006 - 2014 IBM Corporation.  All rights reserved.
 *
 * This software is the property of IBM Corporation and its
 * licensors and contains their confidential trade secrets.  Use, examination,
 * copying, transfer and disclosure to others, in whole or in part, are
 * prohibited except with the express prior written consent of
 * IBM Corporation.
 *
 */
 
require 'thread'

load 'general.rb'
load 'properties.rb'
load 'map.rb'
load 'dtxdefs.rb'

$num_maps = 1
$mutex = Mutex.new

def check_err(rc)
	if ((rc) <= MPIRC_TYPE_ERROR)
		puts "Last error is: " + General.mpiErrorGetText(rc)
		exit -1
	end
end

def RunMap(hMap)
	rc = Map.mpiMapRun(hMap)
	$mutex.synchronize {
		$num_maps = $num_maps - 1
	}
end

rc = General.mpiInitAPI(nil)
check_err(rc)

hMap1 = FFI::MemoryPointer.new :pointer
rc = Map.mpiMapLoadFile(hMap1, "test2.mmc")
check_err(rc)
hMap2 = FFI::MemoryPointer.new :pointer
rc = Map.mpiMapLoadFile(hMap2, "test2.mmc")
check_err(rc)

hMap1 = hMap1.get_pointer(0)
hMap2 = hMap2.get_pointer(0)

rc = Properties.mpiPropertySetInteger(hMap1.address, MPIP_MAP_USE_RESOURCE_MANAGER, 0, 1)
check_err(rc)
rc = Properties.mpiPropertySetInteger(hMap2.address, MPIP_MAP_USE_RESOURCE_MANAGER, 0, 1)
check_err(rc)

t1 = Thread.new{ RunMap(hMap1.address) }

$mutex.synchronize {
	$num_maps = $num_maps + 1
}
 
t2 = Thread.new{ RunMap(hMap2.address) }

while $num_maps != 0
	sleep(10)
end

t1.join
t2.join

zero = FFI::MemoryPointer.new(:int, 1)
szMsg = FFI::MemoryPointer.new :pointer
rc = Properties.mpiPropertyGetText(hMap1.address, MPIP_OBJECT_ERROR_MSG, 0, szMsg, zero)
check_err(rc)
szMsgPtr = szMsg.read_pointer()
iRC = FFI::MemoryPointer.new(:int, 1)
rc = Properties.mpiPropertyGetInteger(hMap1.address, MPIP_OBJECT_ERROR_CODE, 0, iRC)
check_err(rc)
puts "Map status: " + szMsgPtr.read_string() + " (" + iRC.get_int(0).to_s + ")"

zero = FFI::MemoryPointer.new(:int, 1)
szMsg = FFI::MemoryPointer.new :pointer
rc = Properties.mpiPropertyGetText(hMap2.address, MPIP_OBJECT_ERROR_MSG, 0, szMsg, zero)
check_err(rc)
szMsgPtr = szMsg.read_pointer()
iRC = FFI::MemoryPointer.new(:int, 1)
rc = Properties.mpiPropertyGetInteger(hMap2.address, MPIP_OBJECT_ERROR_CODE, 0, iRC)
check_err(rc)
puts "Map status: " + szMsgPtr.read_string() + " (" + iRC.get_int(0).to_s + ")"

rc = Map.mpiMapUnload(hMap1.address)
check_err(rc)
rc = Map.mpiMapUnload(hMap2.address)
check_err(rc)

rc = General.mpiTermAPI()
check_err(rc)