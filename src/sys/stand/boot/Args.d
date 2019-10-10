#include "<df>/dragonfruit.h"

var ArgsBuffer 0

procedure ArgsInit { argp -- }
	if (argp@ 0 ==)
		return
	end

	argp@ ArgsBuffer!
end

procedure ArgsValue { arg -- out }
	if (ArgsBuffer@ 0 ==)
		0 return
	end

	auto wordbuf
	256 Calloc wordbuf!

	auto namebuf
	256 Calloc namebuf!

	auto nt
	ArgsBuffer@ nt!

	0 out!

	while (nt@ 0 ~=)
		auto rmnd

		nt@ wordbuf@ ' ' 255 strntok nt!
		wordbuf@ namebuf@ '=' 255 strntok 1 + rmnd!
		if (namebuf@ arg@ strcmp)
			256 Calloc out!

			out@ rmnd@ strcpy

			break
		end
	end

	wordbuf@ Free
	namebuf@ Free
end

procedure ArgsCheck { arg -- present }
	if (ArgsBuffer@ 0 ==)
		0 return
	end

	auto wordbuf
	256 Calloc wordbuf!

	auto nt
	ArgsBuffer@ nt!

	0 present!

	while (nt@ 0 ~=)
		nt@ wordbuf@ ' ' 255 strntok nt!
		if (wordbuf@ arg@ strcmp)
			1 present! break
		end
	end

	wordbuf@ Free

	present@
end