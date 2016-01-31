
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

module Adapter
	extend FFI::Library
	ffi_lib 'dtxpi'
	
	typedef :int, :MPIRC
	typedef :pointer, :HMPIADAPT
	typedef :long, :HMPIADAPTL
	typedef :long, :HMPICARD
	typedef :pointer, :HMPICARDP
	typedef :pointer, :MPICOMP
	typedef :long, :HMPICONNECT
	typedef :int, :MPITRANS
	typedef :long, :HMPIOBJ
	typedef :pointer, :HMPISTREAM
	typedef :int, :LPEXTDATASERVICEHANDLER # FIND OUT WHAT TYPE THIS ACTUALLY IS
	typedef :pointer, :LPEXTDATASERVICEHANDLERP
	typedef :pointer, :MPI_ADAPTER_VTABLEP
	
	attach_function :mpiAdapterCreate, 
					[:HMPIADAPT, :HMPICARD, :MPI_ADAPTER_VTABLEP], 
					:MPIRC
	attach_function :mpiAdaptCompareWatches, 
					[:HMPIADAPTL, :HMPIADAPTL, :MPICOMP], 
					:MPIRC
	attach_function :mpiAdaptCompareResources,
					[:HMPIADAPTL, :HMPIADAPTL, :MPICOMP],
					:MPIRC
	attach_function :mpiAdaptGet, [:HMPIADAPTL, :HMPICONNECT], :MPIRC
	attach_function :mpiAdaptPut, [:HMPIADAPTL, :HMPICONNECT], :MPIRC
	attach_function :mpiAdaptBeginTransaction, [:HMPIADAPTL, :HMPICONNECT], :MPIRC
	attach_function :mpiAdaptEndTransaction, 
					[:HMPIADAPTL, :HMPICONNECT, :MPITRANS],
					:MPIRC
	attach_function :mpiAdaptListen, [:HMPIADAPTL, :HMPICONNECT], :MPIRC
	attach_function :mpiAdaptValidateProperties, [:HMPIADAPTL], :MPIRC
	attach_function :mpiAdaptValidateConnection, [:HMPIADAPTL, :HMPICONNECT], :MPIRC
	attach_function :mpiAdaptCompareConnection, 
					[:HMPIADAPTL, :HMPICONNECT, :MPICOMP],
					:MPIRC
	attach_function :mpiAdaptGetCardObject, [:HMPIADAPTL, :HMPICARDP], :MPIRC
	attach_function :mpiAdaptGetInputStreamObject, [:HMPIADAPTL, :HMPISTREAM], :MPIRC
	attach_function :mpiAdaptGetOutputStreamObject, [:HMPIADAPT, :HMPISTREAM], :MPIRC
	attach_function :mpiAdaptSetExternalDataHandler, 
					[:HMPIADAPTL, :LPEXTDATASERVICEHANDLER],
					:MPIRC
	attach_function :mpiAdaptGetExternalDataHandler,
					[:HMPIADAPTL, :LPEXTDATASERVICEHANDLERP],
					:MPIRC
	attach_function :mpiAdaptCanSetInputDataObject, [:HMPIADAPTL, :pointer], :MPIRC
	attach_function :mpiAdaptGetInputDataObject, [:HMPIADAPTL, :pointer],  :MPIRC
	attach_function :mpiAdaptSetInputDataObject, [:HMPIADAPTL, :pointer], :MPIRC
	attach_function :mpiAdaptCanGetOutputDataObject, [:HMPIADAPTL, :pointer], :MPIRC
	attach_function :mpiAdaptGetOutputDataObject, [:HMPIADAPTL, :pointer], :MPIRC
	attach_function :mpiAdaptSetOutputDataObject, [:HMPIADAPTL, :pointer], :MPIRC
end
