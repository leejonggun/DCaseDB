Import("Deos.DCaseCloud");
Import("Type.Json");


void main() {

	API repo = new API("konoha","konoha");
	DCaseArgument argument = repo.GetArgument(1);
	System.p(argument.toJson());
}

main();
