
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
 
load 'dtxdefs.rb'
load 'general.rb'
load 'properties.rb'
load 'map.rb'
load 'card.rb'

def check_err(rc)
	if ((rc) <= MPIRC_TYPE_ERROR)
		puts "Last error is: " + General.mpiErrorGetText(rc)
		exit 0
	end
end

rc = General.mpiInitAPI(nil)
check_err(rc)

hMap = FFI::MemoryPointer.new :pointer
rc = Map.mpiMapLoadFile(hMap, "test3.mmc")
check_err(rc)

hMap = hMap.get_pointer(0)

# Turn on burst and summary execution audit on the map instance
rc = Properties.mpiPropertySetInteger(hMap.address, MPIP_MAP_AUDIT_SWITCH, 0, MPI_SWITCH_ON)
check_err(rc)

rc = Properties.mpiPropertySetInteger(hMap.address, MPIP_MAP_AUDIT_BURST_EXECUTION, 0, MPI_SWITCH_ON)
check_err(rc)

rc = Properties.mpiPropertySetInteger(hMap.address, MPIP_MAP_AUDIT_SUMMARY_EXECUTION, 0, MPI_SWITCH_ON)
check_err(rc)

# Get the adapter object handle
hInputCard1 = FFI::MemoryPointer.new :pointer
rc = Map.mpiMapGetInputCardObject(hMap.address, 1, hInputCard1)
check_err(rc)

hInputCard1 = hInputCard1.get_pointer(0)

rc = Card.mpiCardOverrideAdapter(hInputCard1.address, "GZIP", 0)
check_err(rc)

hAdapter = FFI::MemoryPointer.new :pointer
rc = Card.mpiCardGetAdapterObject(hInputCard1.address, hAdapter)
check_err(rc)

hAdapter = hAdapter.get_pointer(0)

zero = FFI::MemoryPointer.new(:int, 1)
# Build the full path using the user defined working directory
rc = Properties.mpiPropertyGetText(hAdapter.address, MPIP_ADAPTER_COMMANDLINE, 0, "", zero)

# Set a command line for the adapter
rc = Properties.mpiPropertySetText(hAdapter.address, MPIP_ADAPTER_COMMANDLINE, 0, "-FILE input.gz", 0)
check_err(rc)

rc = Map.mpiMapRun(hMap.address)
check_err(rc)

zero = FFI::MemoryPointer.new(:int, 1)
szMsg = FFI::MemoryPointer.new :pointer
rc = Properties.mpiPropertyGetText(hMap.address, MPIP_OBJECT_ERROR_MSG, 0, szMsg, zero)
check_err(rc)

szMsgPtr = szMsg.read_pointer()

iRC = FFI::MemoryPointer.new(:int, 1)
rc = Properties.mpiPropertyGetInteger(hMap.address, MPIP_OBJECT_ERROR_CODE, 0, iRC)
check_err(rc)

puts "Map status: " + szMsgPtr.read_string + " (" +  iRC.get_int(0).to_s + ")"

rc = Map.mpiMapUnload(hMap.address)
check_err(rc)

rc = General.mpiTermAPI()
check_err(rc)
