
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
 
load 'general.rb'
load 'properties.rb'
load 'map.rb'
load 'card.rb'
load 'stream.rb'
load 'dtxdefs.rb'

def check_err(rc)
	if ((rc) <= MPIRC_TYPE_ERROR)
		puts "Last error is: " + General.mpiErrorGetText(rc)
		exit 0
	end
end

rc = General.mpiInitAPI(nil)
check_err(rc)

# Load a local map file
fp = File.open("test6.mmc", "rb").read
nSizeOfData = fp.size
szMMCBuffer = FFI::MemoryPointer.new(:char, nSizeOfData)
szMMCBuffer.put_bytes(0, fp)

hMap = FFI::MemoryPointer.new :pointer
rc = Map.mpiMapLoadMemory(hMap, "test6", nil, szMMCBuffer, nSizeOfData)
check_err(rc)

hMapPtr = hMap.get_pointer(0).address

# Get the adapter object handle for input card #1
hCard = FFI::MemoryPointer.new :pointer
rc = Map.mpiMapGetInputCardObject(hMapPtr, 1, hCard)
check_err(rc)

hCardPtr = hCard.get_pointer(0).address

# Override the adapter in input card #1 to be a stream
rc = Card.mpiCardOverrideAdapter(hCardPtr, nil, MPI_ADAPTYPE_STREAM)
check_err(rc)

# Read the local data file
szInputBuffer = File.open("dtxpi/dtxpi/input.txt", "r").read
nSizeOfData = szInputBuffer.size

# Get the handle to the adapter object
hAdapter = FFI::MemoryPointer.new :pointer
rc = Card.mpiCardGetAdapterObject(hCardPtr, hAdapter)
check_err(rc)

hAdapterPtr = hAdapter.get_pointer(0).address

# Get the handle to the stream object
hStream = FFI::MemoryPointer.new :pointer
rc = Properties.mpiPropertyGetObject(hAdapterPtr, MPIP_ADAPTER_DATA_FROM_ADAPT, 0, hStream)
check_err(rc)

hStreamPtr = hStream.get_pointer(0).address

# Send a single large page
rc = Stream.mpiStreamWrite(hStreamPtr, szInputBuffer, nSizeOfData)
check_err(rc)

# Get the adapter object handle for output card #1
rc = Map.mpiMapGetOutputCardObject(hMapPtr, 1, hCard)
check_err(rc)

rc = Map.mpiMapRun(hMapPtr)
check_err(rc)

szMsg = FFI::MemoryPointer.new :pointer
nLen = FFI::MemoryPointer.new(:size_t, 1)
rc = Properties.mpiPropertyGetText(hMapPtr, MPIP_OBJECT_ERROR_MSG, 0, szMsg, nLen)
check_err(rc)

szMsgPtr = szMsg.read_pointer

iRC = FFI::MemoryPointer.new(:int, 1)
rc = Properties.mpiPropertyGetInteger(hMapPtr, MPIP_OBJECT_ERROR_CODE, 0, iRC)
check_err(rc)

puts "Map status: " + szMsgPtr.read_string + " (" + iRC.inspect.to_i.to_s + ")"

# Get the adapter object handle for output card #1
rc = Card.mpiCardGetAdapterObject(hCardPtr, hAdapter)
check_err(rc)

# Get the handle to the stream object
rc = Properties.mpiPropertyGetObject(hAdapterPtr, MPIP_ADAPTER_DATA_TO_ADAPT, 0, hStream)
check_err(rc)

# Get the data in pieces from the stream
Stream.mpiStreamSeek(hStreamPtr, 0, IO::SEEK_SET)

loop {
	bIsEnd = FFI::MemoryPointer.new(:int, 1)
	rc = Stream.mpiStreamIsEnd(hStreamPtr, bIsEnd)
	check_err(rc)
	
	# Clean and break
	if (bIsEnd.get_int(0) == 1) 
		rc = Stream.mpiStreamSetSize(hStreamPtr, 0)
		break
	end
	
	hPage = FFI::MemoryPointer.new :pointer
	rc = Stream.mpiStreamReadPage(hStreamPtr, hPage)
	check_err(rc)
	
	hPagePtr = hPage.get_pointer(0).address
	
	maxBufferLen = 1024
	pData = FFI::MemoryPointer.new(:pointer, maxBufferLen)
	nSizeOfData = FFI::MemoryPointer.new(:size_t, 1)
	rc = Stream.mpiStreamPageGetInfo(hPagePtr, pData, nSizeOfData)
	check_err(rc)
	
	nSizeOfData = nSizeOfData.get_int(0)

	puts pData.get_bytes(0, nSizeOfData)
}

rc = Map.mpiMapUnload(hMapPtr)
check_err(rc)

rc = General.mpiTermAPI()
check_err(rc)
