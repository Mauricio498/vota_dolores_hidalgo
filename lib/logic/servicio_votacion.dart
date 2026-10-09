import '../models/votacion.dart';
import '../models/opcion_votacion.dart';
import '../models/resultado_opcion.dart';
import 'resultado_voto.dart';

class ServicioVotacion {
  final Votacion votacion;
  ServicioVotacion(this.votacion);

  // Rondas 1, 2, 3, 7 y 8 (version final refactorizada)
  ResultadoVoto registrarVoto({required String idUsuario, required String idOpcion}) {
    final yaCerro = DateTime.now().isAfter(votacion.fechaCierre);
    if (yaCerro) return ResultadoVoto.votacionCerrada;

    final yaVoto = votacion.votantes.contains(idUsuario);
    if (yaVoto) return ResultadoVoto.usuarioYaVoto;

    final opcion = _buscarOpcion(idOpcion);
    if (opcion == null) return ResultadoVoto.opcionInvalida;

    opcion.votos++;
    votacion.votantes.add(idUsuario);
    return ResultadoVoto.exitoso;
  }

  // Ronda 4
 List<ResultadoOpcion> obtenerResultados() {
  final total = votacion.opciones.fold<int>(0, (suma, o) => suma + o.votos);
  return votacion.opciones.map((o) {
    final porcentaje = total == 0 ? 0.0 : (o.votos / total) * 100;
    return ResultadoOpcion(opcion: o, porcentaje: porcentaje);
  }).toList();
}

  // Rondas 5 y 6 (regresa todas las opciones con el maximo, por eso detecta empates)
  List<OpcionVotacion> determinarGanador() {
    final maxVotos = votacion.opciones.map((o) => o.votos).reduce((a, b) => a > b ? a : b);
    return votacion.opciones.where((o) => o.votos == maxVotos).toList();
  }

  OpcionVotacion? _buscarOpcion(String id) {
    for (final o in votacion.opciones) {
      if (o.id == id) return o;
    }
    return null;
  }
}
