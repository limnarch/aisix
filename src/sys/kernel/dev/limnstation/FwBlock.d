(* unix-like interface for a3x block devices *)

table FwBlockBDEVSW
	pointerof FwBlockOpen
	pointerof FwBlockClose
	pointerof FwBlockIoctl
	pointerof FwBlockRead
	pointerof FwBlockWrite
	pointerof FwBlockSize
endtable

struct FwBlockDev
	4 WriteMethod
	4 ReadMethod
	4 Size
	4 Path
	4 Node
endstruct

var FwBlockMajor 0
var FwBlockTable 0

const FwBlockCount 4

procedure FwBlockInit (* -- *)
	FwBlockBDEVSW DRIVER_BLOCK "bfw" DeviceAddDriver FwBlockMajor!

	FwBlockDev_SIZEOF FwBlockCount * Calloc FwBlockTable!

	auto i
	0 i!

	while (i@ FwBlockCount <)
		auto bfwn
		15 Calloc bfwn!

		bfwn@ "bfw" strcpy
		i@ bfwn@ 3 + itoa

		0 0 bfwn@ i@ FwBlockMajor@ DeviceAdd

		i@ 1 + i!
	end

	auto bbfw
	0 FwBlockMinorToBFW bbfw!

	if (bbfw@ iserr)
		return
	end

	"[BOOTNODE]" a3xBootNode@ bbfw@ FwBlockAssign drop
end

procedure FwBlockMinorToBFW (* minor -- bfw *)
	auto minor
	minor!

	if (minor@ FwBlockCount >=)
		-ENODEV return
	end

	auto bfw

	FwBlockTable@ minor@ FwBlockDev_SIZEOF * + bfw!

	bfw@
end

procedure FwBlockAssign (* path node bfw -- err *)
	auto bfw
	bfw!

	auto node
	node!

	auto path
	path!

	auto rs
	InterruptDisable rs!

	auto rm
	auto wm
	auto sz

	node@ a3xDeviceSelectNode
		"readBlock" a3xDGetMethod rm!
		"writeBlock" a3xDGetMethod wm!
		"blocks" a3xDGetProperty sz!
	a3xDeviceExit

	if (sz@ 0 ==)
		rs@ InterruptRestore
		-ENXIO return
	end

	path@ strdup bfw@ FwBlockDev_Path + !

	wm@ bfw@ FwBlockDev_WriteMethod + !
	rm@ bfw@ FwBlockDev_ReadMethod + !
	sz@ bfw@ FwBlockDev_Size + !
	node@ bfw@ FwBlockDev_Node + !

	rs@ InterruptRestore
	0 return
end

procedure FwBlockOpen (* proc minor -- err *)
	auto minor
	minor!

	auto proc
	proc!

	auto dev
	minor@ FwBlockMinorToBFW dev!

	if (dev@ iserr)
		dev@ return
	end

	if (dev@ FwBlockDev_Path + @ 0 ==)
		-ENXIO return
	end

	0
end

procedure FwBlockClose (* proc minor -- err *)
	auto minor
	minor!

	auto proc
	proc!

	auto dev
	minor@ FwBlockMinorToBFW dev!

	if (dev@ iserr)
		dev@ return
	end

	if (dev@ FwBlockDev_Path + @ 0 ==)
		-ENXIO return
	end

	0
end

procedure FwBlockRead (* proc buf minor -- err *)
	auto minor
	minor!

	auto buf
	buf!

	auto proc
	proc!

	auto dev
	minor@ FwBlockMinorToBFW dev!

	if (dev@ iserr)
		dev@ return
	end

	if (dev@ FwBlockDev_Path + @ 0 ==)
		-ENXIO return
	end

	auto rm
	dev@ FwBlockDev_ReadMethod + @ rm!

	if (rm@ 0 ==)
		-ENOTBLK return
	end

	buf@ Buffer_Flags + @ BUFFER_VALID | buf@ Buffer_Flags + !

	dev@ FwBlockDev_Node + @ a3xDeviceSelectNode
		if (buf@ Buffer_Block + @ buf@ Buffer_Blockno + @ rm@ Call 0 s<)
			a3xDeviceExit
			-EIO return
		end
	a3xDeviceExit

	0
end

procedure FwBlockWrite (* proc buf minor -- err *)
	auto minor
	minor!

	auto buf
	buf!

	auto proc
	proc!

	auto dev
	minor@ FwBlockMinorToBFW dev!

	if (dev@ iserr)
		dev@ return
	end

	if (dev@ FwBlockDev_Path + @ 0 ==)
		-ENXIO return
	end

	auto wm
	dev@ FwBlockDev_WriteMethod + @ wm!

	if (wm@ 0 ==)
		-ENOTBLK return
	end

	buf@ Buffer_Flags + @ BUFFER_VALID | buf@ Buffer_Flags + !
	buf@ Buffer_Flags + @ BUFFER_DIRTY ~ & buf@ Buffer_Flags + !

	dev@ FwBlockDev_Node + @ a3xDeviceSelectNode
		if (buf@ Buffer_Block + @ buf@ Buffer_Blockno + @ wm@ Call 0 s<)
			a3xDeviceExit
			-EIO return
		end
	a3xDeviceExit

	0
end

procedure FwBlockIoctl (* proc cmd data minor -- err *)
	auto minor
	minor!

	auto data
	data!

	auto cmd
	cmd!

	auto proc
	proc!

	auto dev
	minor@ FwBlockMinorToBFW dev!

	if (dev@ iserr)
		dev@ return
	end

	if (cmd@ BFWIOCTLSETPATH ==)
		auto rs
		InterruptDisable rs!

		if (dev@ FwBlockDev_Path + @ 0 ~=) (* path can only be assigned once per reboot *)
			rs@ InterruptRestore
			-ENXIO return
		end

		auto node
		data@ a3xDevTreeWalk node!

		if (node@ 0 ==)
			rs@ InterruptRestore
			-ENXIO return
		end

		auto r
		data@ node@ dev@ FwBlockAssign r!

		rs@ InterruptRestore
		r@ return
	end

	if (cmd@ BFWIOCTLGETPATH ==)
		if (dev@ FwBlockDev_Path + @ 0 ==)
			-EIO return
		end

		data@ dev@ FwBlockDev_Path + @ 255 strncpy
	
		0 return
	end

	0
end

procedure FwBlockSize (* proc minor -- size or err *)
	auto minor
	minor!

	auto proc
	proc!

	auto dev
	minor@ FwBlockMinorToBFW dev!

	if (dev@ iserr)
		dev@ return
	end

	if (dev@ FwBlockDev_Path + @ 0 ==)
		-ENXIO return
	end

	dev@ FwBlockDev_Size + @
end