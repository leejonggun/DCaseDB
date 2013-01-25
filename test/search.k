load("../dcasecloud_glue.k");


void main() {

	API repo = new API("konoha","konoha");
	System.p(repo.Search("Syntax"));
	System.p(repo.Search("Syntax","Goal"));
}

main();
