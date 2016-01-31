
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

module General
	extend FFI::Library
	ffi_lib 'dtxpi'
	
	typedef :int, :MPIRC
	
	attach_function :mpiInitAPI, [:string], :MPIRC
	attach_function :mpiTermAPI, [], :MPIRC
	attach_function :mpiErrorGetText, [:MPIRC], :string
end
