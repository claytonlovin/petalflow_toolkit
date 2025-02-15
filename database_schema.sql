
-- Tabela de endereços
CREATE TABLE tb_address (
  id_address SERIAL PRIMARY KEY,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(100) NOT NULL,
  country VARCHAR(100) NOT NULL,
  zip_code VARCHAR(20) NOT NULL,
  number_address VARCHAR(20),
  data_created TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  data_update TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Tabela de empresas
CREATE TABLE tb_company (
  id_company SERIAL PRIMARY KEY, 
  name_company VARCHAR(100) NOT NULL,
  cnpj_company VARCHAR(20) NOT NULL UNIQUE,
  data_created TIMESTAMPTZ DEFAULT NOW(),
  id_address INT,
  FOREIGN KEY (id_address) REFERENCES tb_address(id_address) ON DELETE SET NULL
);

-- Tabela de funções (roles)
CREATE TABLE tb_roles_user (
  id_roles SERIAL PRIMARY KEY, 
  name_roles VARCHAR(20) NOT NULL UNIQUE
);

-- Tabela de usuários
CREATE TABLE tb_object_user (
  id_user SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  surname VARCHAR(50),
  email VARCHAR(100) NOT NULL UNIQUE, 
  password VARCHAR(256) NOT NULL,
  id_company INT,
  id_roles INT,
  FOREIGN KEY (id_roles) REFERENCES tb_roles_user(id_roles) ON DELETE CASCADE,
  FOREIGN KEY (id_company) REFERENCES tb_company(id_company) ON DELETE SET NULL
);

-- Tabela de objetos
CREATE TABLE tb_object (
  id_object SERIAL PRIMARY KEY,
  name_object VARCHAR(20) NOT NULL UNIQUE,
  data_created TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_data_update TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- alter table tb_object_user rename to tb_user;
CREATE TABLE tb_object_user (
  id_object_user INT PRIMARY key unique,
  id_object INT NOT NULL,
  id_user INT NOT NULL,
  data_created TIMESTAMPTZ not null, 
  FOREIGN KEY (id_object) REFERENCES tb_object(id_object) ON DELETE CASCADE,
  FOREIGN KEY (id_user) REFERENCES tb_user(id_user) ON DELETE CASCADE
);

--DROP TRIGGER IF EXISTS trigger_set_id_object_user ON tb_object_user;
--DROP FUNCTION IF EXISTS set_id_object_user;

CREATE OR REPLACE FUNCTION set_id_object_user()
RETURNS TRIGGER AS $$
BEGIN
  NEW.id_object_user := NEW.id_object + NEW.id_user;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_id_object_user
BEFORE INSERT ON tb_object_user
FOR EACH ROW
EXECUTE FUNCTION set_id_object_user();


-- Tabela de status
CREATE TABLE tb_status (
  id_status SERIAL PRIMARY KEY,
  name_status VARCHAR(50) NOT NULL
);

-- Tabela de telas (screens)
CREATE TABLE tb_screen (
  id_screen SERIAL PRIMARY KEY,
  name_screen VARCHAR(20) NOT NULL,
  data_created TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_data_update TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Tabela de ambientes de teste
CREATE TABLE tb_environment_case (
  id_environment SERIAL PRIMARY KEY,
  name_environment VARCHAR(50) NOT NULL UNIQUE,
  environment_func TEXT NOT NULL,
  environment_report TEXT NOT NULL,
  id_status INT NOT NULL,
  id_screen INT NOT NULL,
  data_created TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_data_update TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (id_status) REFERENCES tb_status(id_status) ON DELETE CASCADE,
  FOREIGN KEY (id_screen) REFERENCES tb_screen(id_screen) ON DELETE CASCADE
);
