#include "<df>/platform/a3x/a3x.h"

var IDiskBD 0

procedure IDiskInit (* bootdev -- *)
	IDiskBD!
end

procedure IReadBlock { block buf -- }
	IDiskBD@ a3xDeviceSelectNode
		buf@ block@ "readBlock" a3xDCallMethod drop drop
	a3xDeviceExit
end