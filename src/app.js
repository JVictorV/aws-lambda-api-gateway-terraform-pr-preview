module.exports.handler = async (ev) => {
	console.log("ev: doidera", ev);

	return {
		statusCode: 200,
		headers: {
			"Content-Type": "application/json",
		},
		body: JSON.stringify({ teste: "baile do jaca do preview 2" }),
	};
};
