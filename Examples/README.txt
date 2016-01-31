
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
 
WTX Ruby API


This folder contains the following Ruby wrapper modules for the WTX API:
	-general.rb (General Functions)
	-properties.rb (Properties Functions)
	-dtxdefs.rb (WTX C API Constants)
	-card.rb (MCARD API)
	-map.rb (MMAP API)
	-adapter.rb (MADAPTER API)
	-stream.rb (MSTREAM API)
	
The MCARD, MMAP, MADAPTER, and MSTREAM APIs are fully wrapped with all of their C
functions being included in the WTX Ruby API.  The General and Properties functions
that are wrapped only include the functions necessary to run the example files for
the WTX C API, but can easily be extended to include all functions.

In order to run example5.rb, you must install the ruby gem FFI.  To do this, type:

	gem install ffi
	
FFI is a ruby extension that allows programmatic loading of dynamic C libraries that
can bind functions within those libraries so that they can be called from Ruby code.
So, for each of the above APIs, there is an associated Ruby module that binds each
function in that API to a Ruby object so that it can be called.  The example5.rb 
file demonstrates the use of the WTX Ruby API.  Below is an example of C code from 
example5.c that is converted to Ruby code using FFI:

C code:
	
	HMPIMAP 		hMap;
	MPIRC			rc;
	rc = mpiMapLoadFile (&hMap, "test5.mmc");

Ruby Code:

	require 'ffi'

	module Map
		extend FFI::Library
		ffi_lib 'dtxpi'
		
		typedef :int, :MPIRC
		typedef :pointer, :HMPIMAP
		
		attach_function :mpiMapLoadFile, [:HMPIMAP, :string], :MPIRC
	end

	hMap = FFI::MemoryPointer.new :pointer
	rc = Map.mpiMapLoadFile(hMap, "dtxpi/dtxpi/test5.mmc")
	
The key here is the attach_function method in the Map module.  This method
looks for a function of the same name in the 'dtxpi.dll/libdtxpi.so' file and if it finds
that method, then it allows it to be called from Ruby code by saying 
<module_name>.<method_name>(<arg_list>) as you can see above.  When the function
is called, the types of the arguments passed into that function are checked, 
and if they do not match the arguments of the binding specified in the FFI 
module, then an error occurs.

To run example5.rb, simply type the following in the command prompt:

	ruby example5.rb
	
The output displayed should be:
	Map Status: Map completed successfully (0)
	
In addition, after running the program, two files should be generated,
"dtxpi/dtxpi/result1.txt" and "dtxpi/dtxpi/result2.txt".  The content of
these files should be "This is my input data".

Pre-requistes : IBM WTX for Application Programming v 8.4.1

Installation : WTX Install should be added to the System PATH on Windows or LIBRARY PATH on LINUX