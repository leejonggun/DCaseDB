Import("Deos.DCaseCloud");


void main() {

	API repo = new API("konoha","konoha");
//	System.p(repo.Search("Syntax"));
	//System.p(repo.Search(".ds","Evidence"));
	System.p(repo.Search(".ds","DScriptEvidence"));
	System.p(repo.GetArgument(1));
}

main();
