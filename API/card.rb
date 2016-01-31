
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

module Card
	extend FFI::Library
	ffi_lib 'dtxpi'
	
	typedef :int, :MPIRC
	typedef :long, :HMPICARD
	typedef :pointer, :HMPIADAPT
	typedef :pointer, :HMPIMAP
	
	attach_function :mpiCardGetAdapterObject, [:HMPICARD, :HMPIADAPT], :MPIRC
	attach_function :mpiCardGetMapObject, [:HMPICARD, :HMPIMAP], :MPIRC
	attach_function :mpiCardGetAdapterType, [:HMPICARD, :pointer], :MPIRC
	attach_function :mpiCardOverrideAdapter, [:HMPICARD, :string, :int], :MPIRC
end

