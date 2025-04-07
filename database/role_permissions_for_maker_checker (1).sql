update nsdl.users u  set u.new_password = "WRAUvPIh05h+HIGOx8Pgjw==:4QcwJWxhf0Qb+6NSkCupYvmrBPfwy744Bw9VwjXM/2I=" where u.email_id  = "naikm111123@hsbc.co.in"
update nsdl.users u  set u.new_password = "WRAUvPIh05h+HIGOx8Pgjw==:4QcwJWxhf0Qb+6NSkCupYvmrBPfwy744Bw9VwjXM/2I=" where u.email_id  = "ddpchecker1111123123@ddp.com"

update nsdl.roles_master rm  set role_id  = 5 where rm.role_code  = "DDPMaker"
update nsdl.roles_master rm  set role_id  = 6 where rm.role_code  = "DDPChecker"

INSERT INTO oneture_db.nsdl.role_permissions (role_id,permission_id,status,created_by,created_at,updated_by,updated_at) VALUES
	 (5,4,1,1,'2025-04-02 16:26:27.647',NULL,NULL),
	 (5,5,1,1,'2025-04-02 16:28:13.97',NULL,NULL),
	 (5,6,1,1,'2025-04-02 16:28:14.03',NULL,NULL),


INSERT INTO oneture_db.nsdl.role_permissions (role_id,permission_id,status,created_by,created_at,updated_by,updated_at) VALUES
	 (6,4,1,1,'2025-04-02 16:26:27.647',NULL,NULL),
	 (6,7,1,1,'2025-04-02 16:28:13.97',NULL,NULL),
	 (6,8,1,1,'2025-04-02 16:28:14.03',NULL,NULL),
