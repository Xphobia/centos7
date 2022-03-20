#!/usr/bin/env python3

import pymysql
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, String, create_engine

SQLALCHEMY_DATABASE_URI = ("mysql+pymysql://root:root123.@192.168.0.103:3306/test")


engine = create_engine(SQLALCHEMY_DATABASE_URI, echo=True, max_overflow=5)


Base = declarative_base()

def CpuAlert(Base):
    __tablename__ = 'cpu_alert'

    vm_uuid = Column(String(32), primary_key=True)
    cpu_rate = Column(String(20))


def MemoryAlert(Base):
    pass


def test():
    ret = engine.execute("select * from test.person;")
    print(ret.fetchall())

# test()


DBSession = sessionmaker(bind=engine)
session = DBSession()
Base.metadata.create_all(engine)
cpu0 = CpuAlert(vm_uuid="8", cpu_rate="60%")
session.add(cpu0)
session.commit()
session.close()
