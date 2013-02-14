Import("Deos.DCaseCloud");
Import("JavaStyle.Object");
Import("Type.Json");
//Import("konoha.object");

Strategy makeStrategy(API repo, String description) {
	Json json = new Json();
	json.setString("description",description);
	json.setString("type","Strategy");
	return repo.CreateDBNode(json) as Strategy;
}

Goal makeGoal(API repo, String description) {
	Json json = new Json();
	json.setString("description",description);
	json.setString("type","Goal");
	return repo.CreateDBNode(json) as Goal;
}

Evidence makeEvidence(API repo, String description, boolean flag) {
	Json json = new Json();
	json.setString("description",description);
	json.setBoolean("isEvidence",flag);
	json.setString("type","Evidence");
	return repo.CreateDBNode(json) as Evidence;
}

DScriptEvidence makeDScriptEvidence(API repo, String description, boolean flag) {
	Json json = new Json();
	json.setString("description",description);
	json.setBoolean("isEvidence",flag);
	json.setString("type","DScriptEvidence");
	return repo.CreateDBNode(json) as DScriptEvidence;
}

Context makeContext(API repo, String description) {
	Json json = new Json();
	json.setString("description",description);
	json.setString("type","Context");
	return repo.CreateDBNode(json) as Context;
}

void GenerateTree1(API repo) {
	DCaseArgument argument = repo.CreateArgument("ネットワークに障害要因がない");
	int id = argument.argument_id;

	DBNode root = repo.GetArgument(id).GetRoot();

	Json json = new Json();
	json.setString("IP","192.168.59.75");
	json.setString("OS","ubuntu12.10");
	json.setString("Version","3.2.0-37-generic");
	json.setString("Structure","x86-64");
	json.setString("FTP-Control-Port","21");
	json.setString("FTP-Data-Port","21");
	json.setString("Port","21");
	json.setString("DEST","192.168.59.40");
	json.setString("OS","ubuntu12.04");
	json.setString("Version","3.2.0-37-generic");
	json.setString("Structure","x86-64");
	json.setString("FTP-Control-Port","21");
	json.setString("FTP-Data-Port","21");
	repo.AddContext(id, root.node_id, json);

	Strategy s1 = makeStrategy(repo, "レイヤーレベルで議論する");
	repo.InsertLink(id, root, s1);

	Goal g2_1 = makeGoal(repo, "データリンク層に障害要因がない");
	repo.InsertLink(id, s1 , g2_1);

	Strategy s2 = makeStrategy(repo, "PCや周辺機器の状態により議論する");
	repo.InsertLink(id, g2_1 , s2);

	Goal g3_1 = makeGoal(repo, "ネットワークドライバがインストールされている");
	repo.InsertLink(id, s2, g3_1);
	Evidence e3_1 = makeEvidence(repo, "CheckDriver.ds", true);
	repo.InsertLink(id, g3_1, e3_1);

	Goal g3_2 = makeGoal(repo, "正しいカーネルモジュールがロードされている");
	repo.InsertLink(id, s2, g3_2);
	Evidence e3_2 = makeEvidence(repo, "CheckMOD.ds", true);
	repo.InsertLink(id, g3_2, e3_2);

	Goal g3_3 = makeGoal(repo, "イーサネットカードが認識されている");
	repo.InsertLink(id, s2, g3_3);
	DScriptEvidence e3_3 = makeDScriptEvidence(repo, "CheckNIC.ds", true);
	repo.InsertLink(id, g3_3, e3_3);

	Goal g3_4 = makeGoal(repo, "イーサネットインターフェースが有効になっている");
	repo.InsertLink(id, s2, g3_4);
	Evidence e3_4 = makeEvidence(repo, "Connection.ds", true);
	repo.InsertLink(id, g3_4, e3_4);

	Goal g2_2 = makeGoal(repo, "インターネット層に障害要因がない");
	repo.InsertLink(id, s1 , g2_2);

	Strategy s3 = makeStrategy(repo, "インターネット層の持つ役割を基に議論する");
	repo.InsertLink(id, g2_2 , s3);

	Goal g4_1 = makeGoal(repo, "IPアドレスが割り当てられている");
	repo.InsertLink(id, s3, g4_1);
	DScriptEvidence e4_1 = makeDScriptEvidence(repo, "CheckIPAddress.ds", true);
	repo.InsertLink(id, g4_1, e4_1);

	Goal g4_2 = makeGoal(repo, "ルーティング設定は障害要因ではない");
	repo.InsertLink(id, s3, g4_2);

	Strategy s4 = makeStrategy(repo, "ルーティングテーブルを基に議論する");
	repo.InsertLink(id, g4_2 , s4);

	Goal g5_1 = makeGoal(repo, "直接ルーティング可能である");
	repo.InsertLink(id, s4, g5_1);
	Evidence e5_1 = makeEvidence(repo, "RoutingDirectly.ds", true);
	repo.InsertLink(id, g5_1, e5_1);

	Goal g5_2 = makeGoal(repo, "ゲートウェイを通してルーティング可能である");
	repo.InsertLink(id, s4, g5_2);
	Evidence e5_2 = makeEvidence(repo, "RoutingDefault.ds", true);
	repo.InsertLink(id, g5_2, e5_2);

	Goal g4_3 = makeGoal(repo, "firewall設定によりIPレベルでパケットが破棄されない");
	repo.InsertLink(id, s3, g4_3);

	Strategy s5 = makeStrategy(repo, "INPUT, FORWARD, OUTPUT別に確認する");
	repo.InsertLink(id, g4_3, s5);

	Goal g6_1 = makeGoal(repo, "INPUTチェーンでパケットを破棄していない");
	repo.InsertLink(id, s5, g6_1);
	DScriptEvidence e6_1 = makeDScriptEvidence(repo, "FirewallIPInput.ds", true);
	repo.InsertLink(id, g6_1, e6_1);

	Goal g6_2 = makeGoal(repo, "FORWARDチェーンでパケットを破棄していない");
	repo.InsertLink(id, s5, g6_2);
	DScriptEvidence e6_2 = makeDScriptEvidence(repo, "FirewallIPForward.ds", true);
	repo.InsertLink(id, g6_2, e6_2);

	Goal g6_3 = makeGoal(repo, "OUTPUTチェーンでパケットを破棄していない");
	repo.InsertLink(id, s5, g6_3);
	DScriptEvidence e6_3 = makeDScriptEvidence(repo, "FirewallIPOutput.ds", true);
	repo.InsertLink(id, g6_3, e6_3);

	Goal g = makeGoal(repo, "firewall設定によりPOLICYで基本的にパケットが破棄されない");
	repo.InsertLink(id, s3, g);

	Strategy s = makeStrategy(repo, "INPUT, FORWARD, OUTPUT別に確認する");
	repo.InsertLink(id, g, s);

	Goal g = makeGoal(repo, "INPUTチェーンで基本的にパケットを破棄していない");
	repo.InsertLink(id, s5, g);
	DScriptEvidence e = makeDScriptEvidence(repo, "FirewallPolicyInput.ds", true);
	repo.InsertLink(id, g, e);

	Goal g = makeGoal(repo, "FORWARDチェーンで基本的にパケットを破棄していない");
	repo.InsertLink(id, s5, g);
	DScriptEvidence e = makeDScriptEvidence(repo, "FirewallPolicyForward.ds", true);
	repo.InsertLink(id, g, e);

	Goal g = makeGoal(repo, "OUTPUTチェーンで基本的にパケットを破棄していない");
	repo.InsertLink(id, s5, g);
	DScriptEvidence e = makeDScriptEvidence(repo, "FirewallPolicyOutput.ds", true);
	repo.InsertLink(id, g, e);

	Goal g2_3 = makeGoal(repo, "トランスポート層に障害要因がない");
	repo.InsertLink(id, s1 , g2_3);

	Strategy s6 = makeStrategy(repo, "firewall設定を考慮する");
	repo.InsertLink(id, g2_3, s6);

	Goal g7_1 = makeGoal(repo, "受信するTCPプロトコルのパケットを破棄しない");
	repo.InsertLink(id, s6, g7_1);
	DScriptEvidence e7_1 = makeDScriptEvidence(repo, "FirewallTCPInput.ds", true);
	repo.InsertLink(id, g7_1, e7_1);

	Goal g7_2 = makeGoal(repo, "中継するTCPプロトコルのパケットを破棄しない");
	repo.InsertLink(id, s6, g7_2);
	DScriptEvidence e7_2 = makeDScriptEvidence(repo, "FirewallTCPForward.ds", true);
	repo.InsertLink(id, g7_2, e7_2);

	Goal g7_3 = makeGoal(repo, "送信するTCPプロトコルのパケットを破棄しない");
	repo.InsertLink(id, s6, g7_3);
	DScriptEvidence e7_3 = makeDScriptEvidence(repo, "FirewallTCPOutput.ds", true);
	repo.InsertLink(id, g7_3, e7_3);

	Goal g2_4 = makeGoal(repo, "アプリケーション層に障害要因がない");
	repo.InsertLink(id, s1 , g2_4);

	Strategy s7 = makeStrategy(repo, "サービス毎に考慮する");
	repo.InsertLink(id, g2_4, s7);

	Goal g8_1 = makeGoal(repo, "名前解決に障害要因はない");
	repo.InsertLink(id, s7 , g8_1);
	Evidence e8_1 = makeEvidence(repo, "Nslookup.ds", true);
	repo.InsertLink(id, g8_1, e8_1);

	Goal g9_1 = makeGoal(repo, "ファイル転送は可能である");
	repo.InsertLink(id, s7 , g9_1);

	Strategy s8 = makeGoal(repo, "コントロールコネクションの接続可否について議論する");
	repo.InsertLink(id, g9_1, s8);

	Goal g10_1 = makeGoal(repo, "firewall設定により21番ポートのINPUTパケットを破棄しない");
	repo.InsertLink(id, s8 , g10_1);
	Evidence e10_1 = makeEvidence(repo, "FirewallFTPInput.ds", true);
	repo.InsertLink(id, g10_1, e10_1);

	Goal g10_2 = makeGoal(repo, "firewall設定により21番ポートのFORWARDパケットを破棄しない");
	repo.InsertLink(id, s8 , g10_2);
	Evidence e10_2 = makeEvidence(repo, "FirewallFTPForward.ds", true);
	repo.InsertLink(id, g10_2, e10_2);

	Goal g10_3 = makeGoal(repo, "firewall設定により21番ポートのOUTPUTパケットを破棄しない");
	repo.InsertLink(id, s8 , g10_3);
	Evidence e10_3 = makeEvidence(repo, "FirewallFTPOutput.ds", true);
	repo.InsertLink(id, g10_3, e10_3);

	Goal g10_4 = makeGoal(repo, "ユーザ名、パスワードが間違っていない");
	repo.InsertLink(id, s8 , g10_4);
	Evidence e10_4 = makeEvidence(repo, "ユーザの確認結果", true);
	repo.InsertLink(id, g10_4, e10_4);

//	System.p(repo.GetArgument(id).toJson());
	System.p(repo.GetArgumentIds());
}

void main() {
	API repo = new API("konoha","konoha");
	GenerateTree1(repo);
}

main();
