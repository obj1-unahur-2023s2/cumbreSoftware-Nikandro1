import conocimientos.*

object cumbre {
	const auspiciantes = []
	const participantes = []
	var commitsMinimo = 300
	var esSegura = true
	const actividades = []
	
	method actividades() = actividades
	method esSegura()=esSegura
	method commitsMinimo() = commitsMinimo
	method cambiarMinimoCommits(numeroCommits){
		commitsMinimo = numeroCommits
	}
	method participantes() = participantes
	method auspiciantes() = auspiciantes
	method agregarAuspiciantes(unAuspiciante){
		auspiciantes.add(unAuspiciante)
	}
	method esConflictivo(unPais){
		return unPais.conflictoCon().intersection(auspiciantes).size()>0
	}
	method paisConMasParticipantes(){
		return self.paisesDeLosParticipantes().max({a => self.participantesDeUnPais(a)})
	}
	method paisesDeLosParticipantes(){
		return participantes.map({a=>a.pais()}).asSet()
	}
	method participantesDeUnPais(unPais){
		return participantes.count({a=>a.pais()== unPais})
	}
	method participantesExtranjeros(){
		return participantes.filter({p=> !auspiciantes.contains(p.pais())})
	}
	method esRelevante(){
		return participantes.all({a=>a.esCape()})
	}
	method agregarParticipante(unParticipante){
		participantes.add(unParticipante)
	}
	/////  RESTRICCIONES/////
	method agregarParticipanteSiPuede(unParticipante){
		if (self.puedeEntrar(unParticipante)){
			participantes.add(unParticipante)	
		}else{
			self.error("No puede entrar")
			esSegura = false
		}
	}
	method restrigeElAcceso(unParticipante){
		return self.esConflictivo(unParticipante.pais()) or !self.puedeEntrarSiExtranjero(unParticipante)
	}
	method puedeEntrarSiExtranjero(unParticipante){
		if (unParticipante.esParticipanteExtranjero(self)){
			return self.participantesExtranjeros().size()<2
		} else{
			return false
		}
	}
	method puedeEntrar(unParticipante){
		return unParticipante.puedeIngresar(self) and !self.restrigeElAcceso(unParticipante)
	}
	//////ACTIVIDAD////
	
	method realizarActividad(unParticipante, unaActividad, tiempo){
		actividades.add([unParticipante, unaActividad, tiempo])
		unParticipante.hacerActividad(unaActividad, tiempo)		
	}
	method cantidadDeHorasDeActividades(){
		return actividades.sum({a=>a.get(2)})
	}
	
}

class Pais{
	const conflictoCon = #{}
	method conflictoCon() = conflictoCon
	
	method registrarConflictoCon(unPais){
		conflictoCon.add(unPais)
		unPais.conflictoCon().add(self)
	}
}

class Participante{
	const pais
	const conocimientos = []
	var cantidadCommits = 0
	method pais()= pais
	method conocimientos() = conocimientos
	method agregarConocimiento(unConocimiento){
		conocimientos.add(conocimientos)
	}
	method cantidadCommits() = cantidadCommits
	method esCape()
	method puedeIngresar(cumbre){
		return conocimientos.contains(programacionBasica)
	}
	method esParticipanteExtranjero(cumbre){
		return !cumbre.auspiciantes().contains(self.pais())
	}
	method sumarCommits(unaCantidad){
		cantidadCommits += unaCantidad
	}
	method hacerActividad(unaActividad, tiempo){
		self.agregarConocimiento(unaActividad)
		self.sumarCommits(tiempo*unaActividad.commitsPorHora())
	}
	method tieneUnConocimiento(unConocimiento){
		return conocimientos.contains(unConocimiento)
	}
}

class Programadores inherits Participante{
	var horaCapacitacion = 0
	
	method horaCapacitacion()= horaCapacitacion
	method sumarHoras(unaCantidad){
		horaCapacitacion += unaCantidad
	}
	override method esCape(){
		return cantidadCommits > 500
	}
	override method puedeIngresar(cumbre){
		return super(cumbre) and cantidadCommits >= cumbre.commitsMinimo()
	}
	override method hacerActividad(unaActividad, tiempo){
		super(unaActividad, tiempo)
		horaCapacitacion += tiempo
	}
}

class Especialistas inherits Participante{
	override method esCape(){
		return conocimientos.size() > 2
	}
	override method puedeIngresar(cumbre){
		return super(cumbre) and cantidadCommits >= (cumbre.commitsMinimo() - 100) and conocimientos.contains(objetos)
	}
}

class Gerentes inherits Participante{
	var empresa = nullEmpresa
	override method esCape(){
		return empresa.esMultinacional()
	}
	override method puedeIngresar(cumbre){
		return super(cumbre) and conocimientos.contains(manejoDeGrupos)
	}
}

class Empresa{
	const paises =[]
	method paises() = paises
	method agregarPais(unPais){
		paises.add(unPais)
	}
	method esMultinacional(){
		return paises.size()>=3
	}
}

object nullEmpresa{
	
}