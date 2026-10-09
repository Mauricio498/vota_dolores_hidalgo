
import 'package:vota_dolores_hidalgo/models/votacion.dart';
import 'package:vota_dolores_hidalgo/models/opcion_votacion.dart';
import 'package:vota_dolores_hidalgo/logic/resultado_voto.dart';

class ServicioVotacion {
  final Votacion votacion;
  ServicioVotacion(this.votacion);
  ResultadoVoto registrarVoto({
    required String idUsuario,
    required String idOpcion,
  }) {
    final opcion = _buscarOpcion(idOpcion);
    opcion!.votos++;
    return ResultadoVoto.exitoso;
  }

  OpcionVotacion? _buscarOpcion(String id) {
    for (final o in votacion.opciones) {
      if (o.id == id) return o;
    }
    return null;
  }
}
