from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine, Column, Integer, String, Numeric, Date, ForeignKey, func
from sqlalchemy.orm import sessionmaker, declarative_base, Session
from pydantic import BaseModel
from typing import List, Optional
from datetime import date

# 1. Configuración de la Base de Datos (Ajusta usuario y password)
DATABASE_URL = "postgresql+pg8000://postgres:postgres@localhost:5432/sinic_db"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# 2. Modelos de SQLAlchemy
class InteresadoDB(Base):
    __tablename__ = "interesados"
    id_interesado = Column(Integer, primary_key=True, index=True)
    tipo_documento = Column(String(20), nullable=False)
    numero_documento = Column(String(50), unique=True, nullable=False)
    nombre_completo = Column(String(255), nullable=False)
    tipo_interesado = Column(String(50))

class UnidadAdministrativaDB(Base):
    __tablename__ = "unidad_administrativa"
    id_ua = Column(Integer, primary_key=True, index=True)
    tipo_derecho = Column(String(100), nullable=False)
    matricula_inmobiliaria = Column(String(50), unique=True, nullable=False)
    id_interesado = Column(Integer, ForeignKey("interesados.id_interesado"))

class UnidadEspacialDB(Base):
    __tablename__ = "unidad_espacial"
    id_ue = Column(Integer, primary_key=True, index=True)
    id_ua = Column(Integer, ForeignKey("unidad_administrativa.id_ua"))
    tipo_unidad = Column(String(50), nullable=False)
    area_terreno = Column(Numeric, nullable=False)
    geom = Column(String) 

class TopografiaDB(Base):
    __tablename__ = "topografia_representacion"
    id_topografia = Column(Integer, primary_key=True, index=True)
    id_ue = Column(Integer, ForeignKey("unidad_espacial.id_ue"))
    metodo_levantamiento = Column(String(100), nullable=False)
    fecha_levantamiento = Column(Date, nullable=False)
    geom = Column(String)

class CartografiaDB(Base):
    __tablename__ = "cartografia_catastral"
    id_cartografia = Column(Integer, primary_key=True, index=True)
    escala = Column(String(20), nullable=False)
    fuente = Column(String(100), nullable=False)
    geom = Column(String)

# 3. Esquemas de Pydantic
class InteresadoSchema(BaseModel):
    tipo_documento: str
    numero_documento: str
    nombre_completo: str
    tipo_interesado: str
class InteresadoResponse(InteresadoSchema):
    id_interesado: int
    class Config: orm_mode = True

class UASchema(BaseModel):
    tipo_derecho: str
    matricula_inmobiliaria: str
    id_interesado: Optional[int] = None
class UAResponse(UASchema):
    id_ua: int
    class Config: orm_mode = True

class UESchema(BaseModel):
    id_ua: int
    tipo_unidad: str
    area_terreno: float
    wkt_geom: str 
class UEResponse(BaseModel):
    id_ue: int
    id_ua: int
    tipo_unidad: str
    area_terreno: float
    wkt_geom: Optional[str]
    class Config: orm_mode = True

class TopografiaSchema(BaseModel):
    id_ue: int
    metodo_levantamiento: str
    fecha_levantamiento: date
    wkt_geom: str 
class TopografiaResponse(BaseModel):
    id_topografia: int
    id_ue: int
    metodo_levantamiento: str
    fecha_levantamiento: date
    wkt_geom: Optional[str]
    class Config: orm_mode = True

class CartografiaSchema(BaseModel):
    escala: str
    fuente: str
    wkt_geom: str 
class CartografiaResponse(BaseModel):
    id_cartografia: int
    escala: str
    fuente: str
    wkt_geom: Optional[str]
    class Config: orm_mode = True

# 4. Inicialización
app = FastAPI(title="Sistema de Gestión SINIC1 - LADM_COL")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])

def get_db():
    db = SessionLocal()
    try: yield db
    finally: db.close()

# --- ENDPOINTS CRUD ---

# 1. INTERESADOS
@app.post("/interesados/", response_model=InteresadoResponse)
def crear_interesado(item: InteresadoSchema, db: Session = Depends(get_db)):
    db_item = InteresadoDB(**item.dict())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item

@app.get("/interesados/", response_model=List[InteresadoResponse])
def listar_interesados(db: Session = Depends(get_db)):
    return db.query(InteresadoDB).all()

@app.put("/interesados/{id}", response_model=InteresadoResponse)
def actualizar_interesado(id: int, item: InteresadoSchema, db: Session = Depends(get_db)):
    db_item = db.query(InteresadoDB).filter(InteresadoDB.id_interesado == id).first()
    if not db_item: raise HTTPException(status_code=404, detail="No encontrado")
    for var, value in vars(item).items():
        setattr(db_item, var, value) if value else None
    db.commit()
    db.refresh(db_item)
    return db_item

@app.delete("/interesados/{id}")
def eliminar_interesado(id: int, db: Session = Depends(get_db)):
    db_item = db.query(InteresadoDB).filter(InteresadoDB.id_interesado == id).first()
    if not db_item: raise HTTPException(status_code=404, detail="No encontrado")
    db.delete(db_item)
    db.commit()
    return {"status": "eliminado"}

# 2. UNIDAD ADMINISTRATIVA
@app.post("/unidad-administrativa/", response_model=UAResponse)
def crear_ua(item: UASchema, db: Session = Depends(get_db)):
    db_item = UnidadAdministrativaDB(**item.dict())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item

@app.get("/unidad-administrativa/", response_model=List[UAResponse])
def listar_ua(db: Session = Depends(get_db)):
    return db.query(UnidadAdministrativaDB).all()

@app.put("/unidad-administrativa/{id}", response_model=UAResponse)
def actualizar_ua(id: int, item: UASchema, db: Session = Depends(get_db)):
    db_item = db.query(UnidadAdministrativaDB).filter(UnidadAdministrativaDB.id_ua == id).first()
    if not db_item: raise HTTPException(status_code=404, detail="No encontrado")
    for var, value in vars(item).items():
        setattr(db_item, var, value) if value else None
    db.commit()
    db.refresh(db_item)
    return db_item

@app.delete("/unidad-administrativa/{id}")
def eliminar_ua(id: int, db: Session = Depends(get_db)):
    db_item = db.query(UnidadAdministrativaDB).filter(UnidadAdministrativaDB.id_ua == id).first()
    if not db_item: raise HTTPException(status_code=404, detail="No encontrado")
    db.delete(db_item)
    db.commit()
    return {"status": "eliminado"}

# 3. UNIDAD ESPACIAL
@app.post("/unidad-espacial/", response_model=UEResponse)
def crear_ue(item: UESchema, db: Session = Depends(get_db)):
    query = "INSERT INTO unidad_espacial (id_ua, tipo_unidad, area_terreno, geom) VALUES (:id_ua, :tipo_unidad, :area, ST_GeomFromText(:geom, 9377)) RETURNING id_ue"
    result = db.execute(func.text(query), {"id_ua": item.id_ua, "tipo_unidad": item.tipo_unidad, "area": item.area_terreno, "geom": item.wkt_geom})
    db.commit()
    id_creado = result.fetchone()[0]
    return {**item.dict(), "id_ue": id_creado}

@app.get("/unidad-espacial/", response_model=List[UEResponse])
def listar_ue(db: Session = Depends(get_db)):
    query = "SELECT id_ue, id_ua, tipo_unidad, area_terreno, ST_AsText(geom) as wkt_geom FROM unidad_espacial"
    result = db.execute(func.text(query)).fetchall()
    return [{"id_ue": r[0], "id_ua": r[1], "tipo_unidad": r[2], "area_terreno": r[3], "wkt_geom": r[4]} for r in result]

@app.put("/unidad-espacial/{id}")
def actualizar_ue(id: int, item: UESchema, db: Session = Depends(get_db)):
    query = "UPDATE unidad_espacial SET id_ua=:id_ua, tipo_unidad=:tipo_unidad, area_terreno=:area, geom=ST_GeomFromText(:geom, 9377) WHERE id_ue=:id"
    db.execute(func.text(query), {"id_ua": item.id_ua, "tipo_unidad": item.tipo_unidad, "area": item.area_terreno, "geom": item.wkt_geom, "id": id})
    db.commit()
    return {"status": "actualizado"}

@app.delete("/unidad-espacial/{id}")
def eliminar_ue(id: int, db: Session = Depends(get_db)):
    db.execute(func.text("DELETE FROM unidad_espacial WHERE id_ue = :id"), {"id": id})
    db.commit()
    return {"status": "eliminado"}

# 4. TOPOGRAFÍA
@app.post("/topografia/", response_model=TopografiaResponse)
def crear_topografia(item: TopografiaSchema, db: Session = Depends(get_db)):
    query = "INSERT INTO topografia_representacion (id_ue, metodo_levantamiento, fecha_levantamiento, geom) VALUES (:id_ue, :metodo, :fecha, ST_GeomFromText(:geom, 9377)) RETURNING id_topografia"
    result = db.execute(func.text(query), {"id_ue": item.id_ue, "metodo": item.metodo_levantamiento, "fecha": item.fecha_levantamiento, "geom": item.wkt_geom})
    db.commit()
    id_creado = result.fetchone()[0]
    return {**item.dict(), "id_topografia": id_creado}

@app.get("/topografia/", response_model=List[TopografiaResponse])
def listar_topografia(db: Session = Depends(get_db)):
    query = "SELECT id_topografia, id_ue, metodo_levantamiento, fecha_levantamiento, ST_AsText(geom) FROM topografia_representacion"
    result = db.execute(func.text(query)).fetchall()
    return [{"id_topografia": r[0], "id_ue": r[1], "metodo_levantamiento": r[2], "fecha_levantamiento": r[3], "wkt_geom": r[4]} for r in result]

@app.put("/topografia/{id}")
def actualizar_topografia(id: int, item: TopografiaSchema, db: Session = Depends(get_db)):
    query = "UPDATE topografia_representacion SET id_ue=:id_ue, metodo_levantamiento=:metodo, fecha_levantamiento=:fecha, geom=ST_GeomFromText(:geom, 9377) WHERE id_topografia=:id"
    db.execute(func.text(query), {"id_ue": item.id_ue, "metodo": item.metodo_levantamiento, "fecha": item.fecha_levantamiento, "geom": item.wkt_geom, "id": id})
    db.commit()
    return {"status": "actualizado"}

@app.delete("/topografia/{id}")
def eliminar_topografia(id: int, db: Session = Depends(get_db)):
    db.execute(func.text("DELETE FROM topografia_representacion WHERE id_topografia = :id"), {"id": id})
    db.commit()
    return {"status": "eliminado"}

# 5. CARTOGRAFÍA
@app.post("/cartografia/", response_model=CartografiaResponse)
def crear_cartografia(item: CartografiaSchema, db: Session = Depends(get_db)):
    query = "INSERT INTO cartografia_catastral (escala, fuente, geom) VALUES (:escala, :fuente, ST_GeomFromText(:geom, 9377)) RETURNING id_cartografia"
    result = db.execute(func.text(query), {"escala": item.escala, "fuente": item.fuente, "geom": item.wkt_geom})
    db.commit()
    id_creado = result.fetchone()[0]
    return {**item.dict(), "id_cartografia": id_creado}

@app.get("/cartografia/", response_model=List[CartografiaResponse])
def listar_cartografia(db: Session = Depends(get_db)):
    query = "SELECT id_cartografia, escala, fuente, ST_AsText(geom) FROM cartografia_catastral"
    result = db.execute(func.text(query)).fetchall()
    return [{"id_cartografia": r[0], "escala": r[1], "fuente": r[2], "wkt_geom": r[3]} for r in result]

@app.put("/cartografia/{id}")
def actualizar_cartografia(id: int, item: CartografiaSchema, db: Session = Depends(get_db)):
    query = "UPDATE cartografia_catastral SET escala=:escala, fuente=:fuente, geom=ST_GeomFromText(:geom, 9377) WHERE id_cartografia=:id"
    db.execute(func.text(query), {"escala": item.escala, "fuente": item.fuente, "geom": item.wkt_geom, "id": id})
    db.commit()
    return {"status": "actualizado"}

@app.delete("/cartografia/{id}")
def eliminar_cartografia(id: int, db: Session = Depends(get_db)):
    db.execute(func.text("DELETE FROM cartografia_catastral WHERE id_cartografia = :id"), {"id": id})
    db.commit()
    return {"status": "eliminado"}