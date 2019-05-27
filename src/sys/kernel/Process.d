const PROCMINQUANTUM 10

procedure ProcInit (* -- *)
	"proc: init\n" Printf

	PROCMINQUANTUM "min quantum: %dms\n" Printf

	ListCreate ProcList!
end

(* these functions DO implicitly use the current process *)

(* caller should be aware that this function can return if there is nothing to schedule *)
procedure Schedule (* status return? -- *)
	auto ret
	ret!

	auto status
	status!

	if (InterruptGet)
		"scheduler expects interrupts to be disabled\n" Panic
	end

	auto pln
	ProcList@ ListLength pln!

	if (pln@ 0 ==)
		"nothing to schedule\n" Panic
	end

	250 pln@ / PROCMINQUANTUM max ClockSetInterval

	auto np
	ERR np!

	auto n
	ProcList@ ListHead n!

	while (n@ 0 ~=)
		auto pnode
		n@ ListNodeValue pnode!

		if (pnode@ Proc_Status + @ PRUNNABLE ==)
			pnode@ np!
			n@ ProcList@ ListDelete
			n@ ProcList@ ListAppend
			break
		end

		n@ ListNode_Next + @ n!
	end

	if (np@ ERR ==)
		(* nothing to schedule *)
		return
	end

	status@ CurProc@ Proc_Status + !

	if (ret@)
		np@ kswtch
		return
	end else
		np@ uswtch
	end
end

procedure ProcExit (* -- *)
	
end

(* these functions DO NOT implicitly use the current process *)

procedure MakeProcZero (* func -- proc *)
	"hand-crafting pid 0\n" Printf

	auto func
	func!

	auto myhtta
	3 0 0x1FE000 func@ HTTANew myhtta!
	(* psw of 3: usermode and interrupts enabled, but mmu disabled *)

	auto kr5
	1024 Malloc kr5!

	auto myproc

	0 0 0x1FE000 kr5@ -1 -1 -1 myhtta@ 0 "init" ProcBuildStruct myproc!

	PRUNNABLE myproc@ Proc_Status + !
	1 ProcsRunnable!

	myproc@ ProcList@ ListInsert

	myproc@
end

procedure ProcSkeleton (* rs entry extent page name -- proc *)
	auto name
	name!

	auto page
	page!

	auto extent
	extent!

	auto entry
	entry!

	auto rs
	rs!

	auto pid
	LastPID@ pid!

	LastPID@ 1 + LastPID!

	auto kr5
	1024 Malloc kr5!

	auto kstack
	1024 Malloc kstack!

	auto htta
	rs@ 0 kstack@ entry@ HTTANew htta!

	auto proc
	0 0 kstack@ kr5@ CurProc@ extent@ page@ htta@ pid@ name@ ProcBuildStruct proc!

	PFORKING proc@ Proc_Status + !

	proc@ ProcList@ ListInsert

	proc@
end

procedure ProcDestroy (* proc -- *)
	auto proc
	proc!

	proc@ Proc_cHTTA + @ Free
	proc@ Proc_kr5 + @ Free
	proc@ Proc_kstack + @ Free

	proc@ Proc_Page + @
	proc@ Proc_Extent + @
	PMMFree

	proc@ ProcList@ ListFind ProcList@ ListRemove

	proc@ ProcDestroyStruct
end

procedure ProcDestroyStruct (* proc -- *)
	auto proc
	proc!

	proc@ Proc_Name + @ Free

	proc@ Free
end

procedure ProcBuildStruct (* bounds base kstack kr5 parent extent page chtta pid name -- proc *)
	auto name
	name!

	auto pid
	pid!

	auto chtta
	chtta!

	auto page
	page!

	auto extent
	extent!

	auto parent
	parent!

	auto kr5
	kr5!

	auto kstack
	kstack!

	auto base
	base!

	auto bounds
	bounds!

	auto proc
	Proc_SIZEOF Malloc proc!

	name@ strdup proc@ Proc_Name + !
	pid@ proc@ Proc_PID + !
	chtta@ proc@ Proc_cHTTA + !
	page@ proc@ Proc_Page + !
	extent@ proc@ Proc_Extent + !
	parent@ proc@ Proc_Parent + !
	PNONE proc@ Proc_Status + !
	kr5@ proc@ Proc_kr5 + !
	kstack@ proc@ Proc_kstack + !
	base@ proc@ Proc_Base + !
	bounds@ proc@ Proc_Bounds + !

	proc@
end