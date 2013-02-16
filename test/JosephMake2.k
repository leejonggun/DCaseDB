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
	DCaseArgument argument = repo.CreateArgument("ネットワークに障害要因はない");
	int id = argument.argument_id;

	DBNode root = repo.GetArgument(id).GetRoot();

	Json json = new Json();
	json.setString("HOST-IP","192.168.59.75");
	json.setString("OS","ubuntu12.10");
	json.setString("Version","3.2.0-37-generic");
	json.setString("Structure","x86-64");
	json.setString("FTP-Control-Port","21");
	json.setString("FTP-Data-Port","21以外");
	json.setString("Port","21");
	json.setString("DEST","test");
	json.setString("DEST-IP","192.168.59.40");
	json.setString("OS","ubuntu12.04");
	json.setString("Version","3.2.0-37-generic");
	json.setString("Structure","x86-64");
	json.setString("FTP-Control-Port","21");
	json.setString("FTP-Data-Port","21以外");
	repo.AddContext(id, root.node_id, json);

	Strategy s0 = makeStrategy(repo, "レイヤーレベルで議論する");
	repo.InsertLink(id, root, s0);

	Goal g1 = makeGoal(repo, "データリンク層に障害要因がない");
	repo.InsertLink(id, s0 , g1);

	Strategy s1 = makeStrategy(repo, "PCや周辺機器の状態により議論する");
	repo.InsertLink(id, g1 , s1);

	Goal g1_1 = makeGoal(repo, "ネットワークドライバがインストールされている");
	repo.InsertLink(id, s1, g1_1);
	Evidence e1_1 = makeEvidence(repo, "CheckDriver.ds", true);
	repo.InsertLink(id, g1_1, e1_1);

	Goal g1_2 = makeGoal(repo, "正しいカーネルモジュールがロードされている");
	repo.InsertLink(id, s1, g1_2);
	Evidence e1_2 = makeEvidence(repo, "CheckMOD.ds", true);
	repo.InsertLink(id, g1_2, e1_2);

	Goal g1_3 = makeGoal(repo, "イーサネットカードが認識されている");
	repo.InsertLink(id, s1, g1_3);
	DScriptEvidence e1_3 = makeDScriptEvidence(repo, "CheckNIC.ds", true);
	repo.InsertLink(id, g1_3, e1_3);

	Goal g1_4 = makeGoal(repo, "イーサネットインターフェースが有効になっている");
	repo.InsertLink(id, s1, g1_4);
	Evidence e1_4 = makeEvidence(repo, "Connection.ds", true);
	repo.InsertLink(id, g1_4, e1_4);

	Goal g2 = makeGoal(repo, "インターネット層に障害要因がない");
	repo.InsertLink(id, s0 , g2);

	Strategy s2_1 = makeStrategy(repo, "インターネット層の持つ役割を基に議論する");
	repo.InsertLink(id, g2 , s2_1);

	Goal g2_1 = makeGoal(repo, "IPアドレスが割り当てられている");
	repo.InsertLink(id, s2_1, g2_1);
	DScriptEvidence e2_1 = makeDScriptEvidence(repo, "CheckIPAddress.ds", true);
	repo.InsertLink(id, g2_1, e2_1);

	Goal g2_2 = makeGoal(repo, "ルーティング設定は障害要因ではない");
	repo.InsertLink(id, s2_1, g2_2);

	Strategy s2_2 = makeStrategy(repo, "ルーティングテーブルを基に議論する");
	repo.InsertLink(id, g2_2 , s2_2);

	Goal g2_2_1 = makeGoal(repo, "直接ルーティング可能である");
	repo.InsertLink(id, s2_2, g2_2_1);
	Evidence e2_2_1 = makeEvidence(repo, "RoutingDirectly.ds", true);
	repo.InsertLink(id, g2_3, e2_2_1);

	Goal g2_2_2 = makeGoal(repo, "ゲートウェイを通してルーティング可能である");
	repo.InsertLink(id, s2_2, g2_2_2);
	Evidence e2_2_2 = makeEvidence(repo, "RoutingDefault.ds", true);
	repo.InsertLink(id, g5_2, e2_2_2);

	Goal g2_3 = makeGoal(repo, "firewall設定によりIPレベルでパケットが破棄されない");
	repo.InsertLink(id, s2_1, g2_3);

	Strategy s2_3 = makeStrategy(repo, "INPUT, FORWARD, OUTPUT別に確認する");
	repo.InsertLink(id, g2_3, s2_3);

	Goal g2_3_1 = makeGoal(repo, "INPUTチェーンでパケットを破棄していない");
	repo.InsertLink(id, s2_3, g2_3_1);
	DScriptEvidence e2_3_1 = makeDScriptEvidence(repo, "FirewallIPInput.ds", true);
	repo.InsertLink(id, g2_3_1, e2_3_1);

	Goal g2_3_2 = makeGoal(repo, "FORWARDチェーンでパケットを破棄していない");
	repo.InsertLink(id, s2_3, g2_3_2);
	DScriptEvidence e2_3_2 = makeDScriptEvidence(repo, "FirewallIPForward.ds", true);
	repo.InsertLink(id, g2_3_2, e2_3_2);

	Goal g2_3_3 = makeGoal(repo, "OUTPUTチェーンでパケットを破棄していない");
	repo.InsertLink(id, s2_3, g2_3_3);
	DScriptEvidence e2_3_3 = makeDScriptEvidence(repo, "FirewallIPOutput.ds", true);
	repo.InsertLink(id, g2_3_3, e2_3_3);

	Goal g2_4 = makeGoal(repo, "firewall設定によりPOLICYでパケットが破棄されない");
	repo.InsertLink(id, s2_1, g2_3_4);

	Strategy s2_4 = makeStrategy(repo, "INPUT, FORWARD, OUTPUT別に確認する");
	repo.InsertLink(id, g3_4, s2_4);

	Goal g2_4_1 = makeGoal(repo, "INPUTチェーンで基本的にパケットを破棄していない");
	repo.InsertLink(id, s2_4, g2_4_1);
	DScriptEvidence e2_4_1 = makeDScriptEvidence(repo, "FirewallPolicyInput.ds", true);
	repo.InsertLink(id, g2_4_1, e2_4_1);

	Goal g2_4_2 = makeGoal(repo, "FORWARDチェーンで基本的にパケットを破棄していない");
	repo.InsertLink(id, s2_4, g2_4_2);
	DScriptEvidence e2_4_2 = makeDScriptEvidence(repo, "FirewallPolicyForward.ds", true);
	repo.InsertLink(id, g2_4_2, e2_4_2);

	Goal g2_4_3 = makeGoal(repo, "OUTPUTチェーンで基本的にパケットを破棄していない");
	repo.InsertLink(id, s2_4, g2_4_3);
	DScriptEvidence e2_4_3 = makeDScriptEvidence(repo, "FirewallPolicyOutput.ds", true);
	repo.InsertLink(id, g2_4_3, e2_4_3);

	Goal g3 = makeGoal(repo, "トランスポート層に障害要因がない");
	repo.InsertLink(id, s0 , g3);

	Strategy s3 = makeStrategy(repo, "firewall設定を考慮する");
	repo.InsertLink(id, g3, s3);

	Goal g3_1 = makeGoal(repo, "受信するTCPプロトコルのパケットを破棄しない");
	repo.InsertLink(id, s3, g3_1);
	DScriptEvidence e3_1 = makeDScriptEvidence(repo, "FirewallTCPInput.ds", true);
	repo.InsertLink(id, g3_1, e3_1);

	Goal g3_2 = makeGoal(repo, "中継するTCPプロトコルのパケットを破棄しない");
	repo.InsertLink(id, s3, g3_2);
	DScriptEvidence e3_2 = makeDScriptEvidence(repo, "FirewallTCPForward.ds", true);
	repo.InsertLink(id, g3_2, e3_2);

	Goal g3_3 = makeGoal(repo, "送信するTCPプロトコルのパケットを破棄しない");
	repo.InsertLink(id, s3, g3_3);
	DScriptEvidence e3_3 = makeDScriptEvidence(repo, "FirewallTCPOutput.ds", true);
	repo.InsertLink(id, g3_3, e3_3);

	Goal g4 = makeGoal(repo, "アプリケーション層に障害要因がない");
	repo.InsertLink(id, s0 , g4);

	Strategy s4 = makeStrategy(repo, "サービス毎に考慮する");
	repo.InsertLink(id, g4, s4);

	Goal g4_1 = makeGoal(repo, "名前解決に障害要因はない");
	repo.InsertLink(id, s4 , g4_1);
	Evidence e4_1 = makeEvidence(repo, "Nslookup.ds", true);
	repo.InsertLink(id, g4_1, e4_1);

	Goal g4_2 = makeGoal(repo, "FTP設定は間違っていない");
	repo.InsertLink(id, s4 , g4_2);

	Strategy s4_2 = makeGoal(repo, "コントロールコネクションの接続可否について議論する");
	repo.InsertLink(id, g4_2, s4_2);

	Goal g4_2_1 = makeGoal(repo, "firewall設定により21番ポートのINPUTパケットを破棄しない");
	repo.InsertLink(id, s4_2 , g4_2_1);
	Evidence e4_2_1 = makeEvidence(repo, "FirewallFTPInput.ds", true);
	repo.InsertLink(id, g4_2_1, e4_2_1);

	Goal g4_2_2 = makeGoal(repo, "firewall設定により21番ポートのFORWARDパケットを破棄しない");
	repo.InsertLink(id, s4_2 , g10_2);
	Evidence e10_2 = makeEvidence(repo, "FirewallFTPForward.ds", true);
	repo.InsertLink(id, g4_2_2, e4_2_2);

	Goal g4_2_3 = makeGoal(repo, "firewall設定により21番ポートのOUTPUTパケットを破棄しない");
	repo.InsertLink(id, s4_2 , g4_2_3);
	Evidence e4_2_3 = makeEvidence(repo, "FirewallFTPOutput.ds", true);
	repo.InsertLink(id, g4_2_3, e4_2_3);

	Goal g4_2_4 = makeGoal(repo, "ユーザ名、パスワードが間違っていない");
	repo.InsertLink(id, s4_2 , g4_2_4);
	Evidence e4_2_4 = makeEvidence(repo, "ユーザの確認結果", true);
	repo.InsertLink(id, g4_2_4, e4_2_4);

	Strategy s4_3 = makeGoal(repo, "データコネクションの接続可否について議論する");
	repo.InsertLink(id, g4_2, s4_3);

	Goal g4_3_1 = makeGoal(repo, "firewall設定によりデータ転送に使用するポートのINPUTパケットを破棄しない");
	repo.InsertLink(id, s4_3 , g4_3_1);
	Evidence e10_1 = makeEvidence(repo, "FirewallFTPDataInput.ds", true);
	repo.InsertLink(id, g10_1, e10_1);

	Goal g4_3_2 = makeGoal(repo, "firewall設定によりデータ転送に使用するポートのFORWARDパケットを破棄しない");
	repo.InsertLink(id, s4_3 , g4_3_2);
	Evidence e4_3_2 = makeEvidence(repo, "FirewallDataForward.ds", true);
	repo.InsertLink(id, g4_3_2, e4_3_2);

	Goal g4_3_3 = makeGoal(repo, "firewall設定によりデータ転送に使用するポートのOUTPUTパケットを破棄しない");
	repo.InsertLink(id, s4_3 , g4_3_3);
	Evidence e4_3_3 = makeEvidence(repo, "FirewallFTPDataOutput.ds", true);
	repo.InsertLink(id, g4_3_3, e4_3_3);

	Strategy s4_4 = makeGoal(repo, "FTP設定について議論する");
	repo.InsertLink(id, g4_2, s4_4);

	Goal g4_4_1 = makeGoal(repo, "匿名で接続できる設定になっている");
	repo.InsertLink(id, s4_4 , g4_4_1);
	Evidence e4_4_1 = makeEvidence(repo, "CheckAnonConf.ds", true);
	repo.InsertLink(id, g4_4_1, e4_4_1);

	Goal g4_4_2 = makeGoal(repo, "匿名で参照できるディレクトリが設定されている");
	repo.InsertLink(id, s4_4 , g4_4_2);
	Evidence e4_4_2 = makeEvidence(repo, "CheckRootConf.ds", true);
	repo.InsertLink(id, g4_4_2, e4_4_2);

//	System.p(repo.GetArgument(id).toJson());
	System.p(repo.GetArgumentIds());
}

void main() {
	API repo = new API("konoha","konoha");
	GenerateTree1(repo);
}
