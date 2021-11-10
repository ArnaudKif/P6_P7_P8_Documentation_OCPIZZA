



-- -----------------------------------------------------
-- Schema ocpizza
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ocpizza` ;
USE `ocpizza` ;

-- -----------------------------------------------------
-- Table `ocpizza`.`Adress`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza`.`Adress` (
  `idAdress` INT NOT NULL AUTO_INCREMENT,
  `street_number` VARCHAR(45) NULL DEFAULT NULL,
  `street_name` VARCHAR(45) NOT NULL,
  `postal_code` CHAR(10) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
 `detail` VARCHAR(155) NULL DEFAULT NULL,
  PRIMARY KEY (`idAdress`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocpizza`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza`.`User` (
  `idUser` INT NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `birth_date` DATE NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `adress` INT NOT NULL,
  PRIMARY KEY (`idUser`),
  INDEX `fk_Utilisateur_Adresse1_idx` (`adress` ASC) VISIBLE,
  CONSTRAINT `fk_Utilisateur_Adresse1`
    FOREIGN KEY (`adress`)
    REFERENCES `ocpizza`.`Adress` (`idAdress`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocpizza`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza`.`Customer` (
  `idCustomer` INT NOT NULL AUTO_INCREMENT,
  `fidelity_points` INT NULL DEFAULT NULL,
  `userID` INT NOT NULL,
  PRIMARY KEY (`idCustomer`),
  INDEX `fk_Client_Utilisateur1_idx` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_Client_Utilisateur1`
    FOREIGN KEY (`userID`)
    REFERENCES `ocpizza`.`User` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocpizza`.`store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza`.`Store` (
  `idStore` INT NOT NULL AUTO_INCREMENT,
  `name_store` VARCHAR(45) NOT NULL,
  `siret` VARCHAR(45) NOT NULL,
  `adressID` INT NOT NULL,
  PRIMARY KEY (`idStore`),
  INDEX `fk_pointDeVente_Adresse1_idx` (`adressID` ASC) VISIBLE,
  CONSTRAINT `fk_pointDeVente_Adresse1`
    FOREIGN KEY (`adressID`)
    REFERENCES `ocpizza`.`Adress` (`idAdress`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocpizza`.`staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza`.`Staff` (
  `idStaff` INT NOT NULL AUTO_INCREMENT,
  `role` ENUM('pizzaiolo', 'livreur', 'responsable') NOT NULL,
  `userID` INT NOT NULL,
  `storeID` INT NOT NULL,
  PRIMARY KEY (`idStaff`),
  INDEX `fk_Personnel_Utilisateur1_idx` (`userID` ASC) VISIBLE,
  INDEX `fk_Personnel_pointDeVente1_idx` (`storeID` ASC) VISIBLE,
  CONSTRAINT `fk_Personnel_Utilisateur1`
    FOREIGN KEY (`userID`)
    REFERENCES `ocpizza`.`User` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Personnel_pointDeVente1`
    FOREIGN KEY (`storeID`)
    REFERENCES `ocpizza`.`Store` (`idStore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocpizza`.`Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza`.`Order` (
  `idOrder` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `orderStatus` ENUM('en attente', 'en préparation', 'annulée', 'prête', 'délivrée', 'prête à livrer', 'en livraison', 'livrée') NOT NULL,
  `delivery` TINYINT NOT NULL DEFAULT 0,
  `paymentValidity` TINYINT NOT NULL DEFAULT 0,
  `customerID` INT NOT NULL,
  `id_store` INT NOT NULL,
  PRIMARY KEY (`idOrder`),
  INDEX `fk_Order_Customer1_idx` (`customerID` ASC) VISIBLE,
  INDEX `fk_Order_store1_idx` (`id_store` ASC) VISIBLE,
  CONSTRAINT `fk_Order_Customer1`
    FOREIGN KEY (`customerID`)
    REFERENCES `ocpizza`.`Customer` (`idCustomer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_store1`
    FOREIGN KEY (`id_store`)
    REFERENCES `ocpizza`.`Store` (`idStore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocpizza`.`Payement`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza`.`Payement` (
  `idPayement` INT NOT NULL AUTO_INCREMENT,
  `typePayement` VARCHAR(45) NULL DEFAULT NULL,
  `payementTime` DATETIME NULL DEFAULT NULL,
  `amount` DOUBLE NULL DEFAULT NULL,
  `order-id` INT NOT NULL,
  PRIMARY KEY (`idPayement`),
  INDEX `fk_Payement_Commande1_idx` (`order-id` ASC) VISIBLE,
  CONSTRAINT `fk_Payement_Commande1`
    FOREIGN KEY (`order-id`)
    REFERENCES `ocpizza`.`Order` (`idOrder`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocpizza`.`Supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza`.`Supplier` (
  `idSupplier` INT NOT NULL AUTO_INCREMENT,
  `supplier_name` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `id_adress` INT NOT NULL,
  PRIMARY KEY (`idSupplier`),
  INDEX `fk_supplier_Adress1_idx` (`id_adress` ASC) VISIBLE,
  CONSTRAINT `fk_supplier_Adress1`
    FOREIGN KEY (`id_adress`)
    REFERENCES `ocpizza`.`Adress` (`idAdress`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocpizza`.`Ingredient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza`.`Ingredient` (
  `idIngredient` INT NOT NULL AUTO_INCREMENT,
  `ingredient_name` VARCHAR(45) NOT NULL,
  `ingredient_info` VARCHAR(45) NULL,
  PRIMARY KEY (`idIngredient`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocpizza`.`Stock`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `ocpizza`.`Stock` (
  `idStock` INT(11) NOT NULL AUTO_INCREMENT,
  `realQuantity` REAL NULL DEFAULT NULL,
  `minQuantity` REAL NOT NULL,
  `id_supplier` INT(11) NOT NULL,
  `id_store` INT(11) NOT NULL,
  `id_Ingredient` INT(11) NOT NULL,
  PRIMARY KEY (`idStock`),
  INDEX `fk_stock_Fournisseur1_idx` (`id_supplier` ASC) VISIBLE,
  INDEX `fk_stock_pointDeVente1_idx` (`id_store` ASC) VISIBLE,
  INDEX `fk_stock_Ingredient1_idx` (`id_Ingredient` ASC) VISIBLE,
  CONSTRAINT `fk_stock_Fournisseur1`
    FOREIGN KEY (`id_supplier`)
    REFERENCES `ocpizza`.`Supplier` (`idSupplier`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_stock_pointDeVente1`
    FOREIGN KEY (`id_store`)
    REFERENCES `ocpizza`.`Store` (`idStore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_stock_Ingredient1`
    FOREIGN KEY (`id_Ingredient`)
    REFERENCES `ocpizza`.`Ingredient` (`idIngredient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocpizza`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza`.`Product` (
  `idProduct` INT(11) NOT NULL AUTO_INCREMENT,
  `category` ENUM('pizza', 'boisson', 'dessert', 'autre plat') NOT NULL,
  `product_name` VARCHAR(45) NOT NULL,
  `product_composition` VARCHAR(255) NOT NULL,
  `small_size` TINYINT(4) NULL DEFAULT 0,
  `priceHT` DECIMAL(9,2) NOT NULL,
  `product_VAT` DECIMAL(5,2) NULL DEFAULT NULL,
  PRIMARY KEY (`idProduct`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocpizza`.`OrderLine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza`.`OrderLine` (
  `idOrder` INT NOT NULL,
  `idProduct` INT NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`idOrder`, `idProduct`),
  INDEX `fk_Commande_has_Produit_Produit1_idx` (`idProduct` ASC) VISIBLE,
  INDEX `fk_Commande_has_Produit_Commande1_idx` (`idOrder` ASC) VISIBLE,
  CONSTRAINT `fk_Commande_has_Produit_Commande1`
    FOREIGN KEY (`idOrder`)
    REFERENCES `ocpizza`.`Order` (`idOrder`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Commande_has_Produit_Produit1`
    FOREIGN KEY (`idProduct`)
    REFERENCES `ocpizza`.`Product` (`idProduct`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocpizza`.`Recipe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza`.`Recipe` (
  `idRecipe` INT(11) NOT NULL AUTO_INCREMENT,
  `recipe_details` VARCHAR(1000) NULL DEFAULT NULL,
  `id_product` INT(11) NOT NULL,
  PRIMARY KEY (`idRecipe`),
  INDEX `fk_Recipe_Product1_idx` (`id_product` ASC) VISIBLE,
  CONSTRAINT `fk_Recipe_Product1`
    FOREIGN KEY (`id_product`)
    REFERENCES `ocpizza`.`Product` (`idProduct`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocpizza`.`Invoice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza`.`Invoice` (
  `idInvoice` INT NOT NULL AUTO_INCREMENT,
  `price` DOUBLE NOT NULL,
  `VAT` DOUBLE NOT NULL,
  `idOrder` INT NOT NULL,
  PRIMARY KEY (`idInvoice`),
  INDEX `fk_Facture_Commande1_idx` (`idOrder` ASC) VISIBLE,
  CONSTRAINT `fk_Facture_Commande1`
    FOREIGN KEY (`idOrder`)
    REFERENCES `ocpizza`.`Order` (`idOrder`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ocpizza`.`IngredientProduct`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza`.`IngredientProduct` (
  `idProduct` INT NOT NULL,
  `idIngredient` INT NOT NULL,
  `quantity` REAL NOT NULL,
  PRIMARY KEY (`idProduct`, `idIngredient`),
  INDEX `fk_Product_has_Ingredient_Ingredient1_idx` (`idIngredient` ASC) VISIBLE,
  INDEX `fk_Product_has_Ingredient_Product1_idx` (`idProduct` ASC) VISIBLE,
  CONSTRAINT `fk_Product_has_Ingredient_Product1`
    FOREIGN KEY (`idProduct`)
    REFERENCES `ocpizza`.`Product` (`idProduct`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_has_Ingredient_Ingredient1`
    FOREIGN KEY (`idIngredient`)
    REFERENCES `ocpizza`.`Ingredient` (`idIngredient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



