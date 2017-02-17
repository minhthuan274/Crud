function deleteRow(id){
		console.log("begin ajax");
		$.ajax({
			url: '/delete/' + id,
			type: 'delete',
		});
		console.log("done ajax");
		$("#item"+id).remove();
	}