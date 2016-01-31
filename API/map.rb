
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
 
require 'rubygems'
require 'ffi'

module Map
	extend FFI::Library
	ffi_lib 'dtxpi'
	
	typedef :int, :MPIRC
	typedef :pointer, :HMPIMAP
	typedef :long, :HMPIMAPL
	typedef :long, :HMPICARD
	typedef :pointer, :HMPICARDP
	typedef :long_long, :QWORD
	
	callback :MPICTRLMTD, [:HMPIMAPL, :int, :int, :int], :void
	callback :MPIRUNMAPLOADMTD, [:HMPIMAPL, :pointer, :pointer], :int
	callback :MPIAUDITLINEMTD,
			 [:HMPIMAPL, :int, :int, :int, :int, :int, :QWORD,
			  :string, :string, :string, :string, :string],
			 :void
	attach_function :mpiMapLoadFile, [:HMPIMAP, :string], :MPIRC
	attach_function :mpiMapLoadMemory, 
					[:HMPIMAP, :string, :string, :pointer, :size_t], 
					:MPIRC
	attach_function :mpiMapSetCardCharset, [:HMPICARD, :int, :uchar], :MPIRC
	attach_function :mpiMapUnload, [:HMPIMAPL], :MPIRC
	attach_function :mpiMapRefresh, [:HMPIMAPL], :MPIRC
	attach_function :mpiMapReloadFile, [:string], :MPIRC
	attach_function :mpiMapReloadMemory, [:string, :string, :string, :size_t], :MPIRC
	attach_function :mpiMapRun, [:HMPIMAPL], :MPIRC
	attach_function :mpiMapPause, [:HMPIMAPL], :MPIRC
	attach_function :mpiMapContinue, [:HMPIMAPL], :MPIRC
	attach_function :mpiMapAbort, [:HMPIMAPL], :MPIRC
	attach_function :mpiMapGetInputCardObject, [:HMPIMAPL, :int, :HMPICARDP], :MPIRC
	attach_function :mpiMapGetOutputCardObject, [:HMPIMAPL, :int, :HMPICARDP], :MPIRC
	attach_function :mpiMapGetInputCardNumber, [:HMPIMAPL, :pointer], :MPIRC
	attach_function :mpiMapGetOutputCardNumber, [:HMPIMAPL, :pointer], :MPIRC
	attach_function :mpiMapGetInputCardCount, [:HMPIMAPL, :pointer], :MPIRC
	attach_function :mpiMapGetOutputCardCount, [:HMPIMAPL, :pointer], :MPIRC
	attach_function :mpiMapRegisterStatusMethod, [:HMPIMAPL, :MPICTRLMTD, :int], :MPIRC
	attach_function :mpiMapRegisterAuditLineMethod, [:HMPIMAPL, :MPIAUDITLINEMTD], :MPIRC
	attach_function :mpiMapGetAuditLineMethod, [:HMPIMAPL, :pointer], :MPIRC
	attach_function :mpiMapRegisterRunMapLoadMethod, [:HMPIMAPL, :MPIRUNMAPLOADMTD], :MPIRC
	attach_function :mpiMapGetRunMapLoadMethod, [:HMPIMAPL, :pointer], :MPIRC
	attach_function :mpiMapReportStatus, [:HMPIMAPL, :string, :pointer], :MPIRC
	attach_function :mpiMapGetAuditData, [:HMPIMAPL, :pointer], :MPIRC
	attach_function :mpiMapGetAuditDataLen, [:HMPIMAPL, :pointer], :MPIRC
	attach_function :mpiMapGetEntityResolver, [:HMPIMAPL, :pointer], :MPIRC
	attach_function :mpiMapSetEntityResolver, [:HMPIMAPL, :pointer], :MPIRC
	
	Map::MPICTRLMTDC = Proc.new do |hMap, iEventID, iBurstNum, iCardNum|
		case iEventID
		when MPI_EVENT_START_INPUT
			puts "Event received = MPI_EVENT_START_INPUT"
		when MPI_EVENT_INPUT_COMPLETE
			puts "Event received = MPI_EVENT_INPUT_COMPLETE"
		when MPI_EVENT_START_OUTPUT
			puts "Event received = MPI_EVENT_START_OUTPUT"
		when MPI_EVENT_OUTPUT_COMPLETE
			puts "Event received = MPI_EVENT_OUTPUT_COMPLETE"
		when MPI_EVENT_START_BURST
			puts "Event received = MPI_EVENT_START_BURST"
		when MPI_EVENT_BURST_COMPLETE
			puts "Event received = MPI_EVENT_BURST_COMPLETE"
		when MPI_EVENT_START_MAP
			puts "Event received = MPI_EVENT_START_MAP"
		when MPI_EVENT_MAP_COMPLETE
			puts "Event received = MPI_EVENT_MAP_COMPLETE"
		else
			puts "Unknown event!!!"
		end
	end
	
end
