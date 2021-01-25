class Transicion(object):
    def __init__(self, inicio, fin, simbolo):
        self.inicio = inicio
        self.fin = fin
        self.simbolo = simbolo
        
    def obtener_atributos(self):
        return self.inicio, self.fin, self.simbolo
    
    def igual(self,tr):
        return True if (self.inicio == tr.inicio and self.fin == tr.fin 
                        and self.simbolo == tr.simbolo) else False
    
    def __repr__(self):
        return self.inicio, self.fin, self.simbolo