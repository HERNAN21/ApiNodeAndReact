CREATE OR REPLACE FUNCTION public.post_solicitud(
	id_aprobador integer,
	id_jefe_directo integer,
	id_gerente integer,
	id_puesto integer,
	cantidad integer,
	id_modalidad integer,
	fecha_estimada_inicio date,
	id_plazo integer,
	nombre_cliente character,
	descripcion_servicio character,
	volumen_motivo character,
	inicio_estimado_tiempo date,
	estimacion_duracion_tiempo character,
	observaciones character,
	descripcion character,
	usuario_registro character,
	estado integer,
	cantidad_plazo character varying,
	id_grupo integer[],
	id_grupo_tipo text[]
	)
    RETURNS e_return
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
	s_id integer;
	e_return e_return;
	BEGIN
		IF inicio_estimado_tiempo<>null THEN
			inicio_estimado_tiempo=now();
		END IF;
		insert into solicitud(id_aprobador,id_jefe_directo,id_gerente,id_puesto,cantidad,id_modalidad,fecha_estimada_inicio, 
			id_plazo,nombre_cliente,descripcion_servicio,volumen_motivo,inicio_estimado_tiempo,estimacion_duracion_tiempo, 
			observaciones, descripcion,fecha_registro,usuario_registro,estado,cantidad_plazo
		)values(
			id_aprobador,id_jefe_directo,id_gerente,id_puesto,cantidad,id_modalidad,fecha_estimada_inicio,id_plazo,nombre_cliente,
			descripcion_servicio,volumen_motivo,inicio_estimado_tiempo,estimacion_duracion_tiempo,observaciones,descripcion,now(),usuario_registro, estado,cantidad_plazo
		)
		returning id into s_id;
		INSERT INTO solicitud_detalle(id_solicitud,id_grupo,id_grupo_tipo,descripcion,fecha_registro,usuario_registro,estado)
		SELECT	s_id,unnest(id_grupo),unnest(id_grupo_tipo),'', now(),usuario_registro,true;
		e_return.id = s_id;
		e_return.text = 'Se registró la solicitud';
		e_return.code = 'S';
		return e_return;
END;
$BODY$;







DROP FUNCTION get_aprobaciones_pendientes;
CREATE OR REPLACE FUNCTION get_aprobaciones_pendientes(codigo_solicitud integer, estado_solicitud integer )
	RETURNS TABLE(
		id integer,id_aprobador integer,id_jefe_directo integer,id_puesto integer,cantidad integer,id_modalidad integer,fecha_estimada_inicio date,id_plazo integer,nombre_cliente varchar(300),descripcion_servicio varchar(100),
		volumen_motivo character(20),inicio_estimado_tiempo date,estimacion_duracion_tiempo varchar(100),observaciones varchar(300),descripcion varchar(200),remuneracion character(20),fecha_registro timestamp,usuario_registro varchar(50),fecha_modificacion timestamp,usuario_modificacion varchar(50),
		estado integer,estado_des integer,estado_des1 integer,estado_vicepresidencia integer,glosa varchar(100),sociedad varchar(100),lider_uo varchar(100),codigo_uo character(50),descripcion_uo varchar(100),cod_divicion varchar(50),
		cod_sub_div varchar(50),sctr varchar(100),id_area_personal varchar(100),id_relacion_personal varchar(100),file_dp varchar(500),direccion integer,tipo_moneda integer,vales character(50),asig_movilidad character(100),asig_otros character(100),
		tipo_moneda_neg integer,remuneracion_neg float, vales_neg character(100),fecha_inicio_neg timestamp,file_ficha_ingreso varchar(150),codigo_area_personal character(100),area_nomina character(100),codigo_laboral character(100),cantidad_plazo character(100),disabled boolean,
 		id_apro integer,codigo_user integer,sociedad_user varchar(100),codigo_division character(50),nombre_division_personal varchar(100),codigo_sub_division character(50),nombres_sub_division varchar(100),dni character(8),nombres varchar(100),apellido_paterno varchar(100),
 		apellido_materno varchar(100),email_corp varchar(100),email_personal varchar(100),codigo_posicion character(20),descripcion_posicion varchar(100),codigo_centro_coste character(20),centro_coste varchar(100),codigo_funcion character(20),funcion varchar(100),codigo_ocupacion character(20),
 		ocupacion varchar(100),codigo_unidad_org character(20),unidad_organizativa varchar(100),fecha_nac date,inicio_contrata date,fin_contrata date,cod_jefe character(20),saldo_dias_vacaion character(20),saldo_dias_descanso character(20),categoria varchar(100),
 		id_jefe integer,codigo_jefe_dir integer,dni_jefe character(8),nombre_jefe varchar(100),apellido_paterno_jefe varchar(100),apellido_materno_jefe varchar(100),email_corp_jefe varchar(100),email_personal_jefe varchar(100),codigo_posicion_jefe character(20),descripcion_posicion_jefe varchar(100),
 		codigo_centro_coste_jefe character(20),centro_coste_jefe varchar(100),codigo_funcion_jefe character(20),funcion_jefe varchar(100),codigo_ocupacion_jefe character(20),ocupacion_jefe varchar(100),codigo_unidad_org_jefe character(20),unidad_organizativa_jefe varchar(100),fecha_nac_jefe date,inicio_contrata_jefe date,
 		fin_contrata_jefe date,cod_jefe_jefe character(20),saldo_dias_vacaion_jefe character(20),saldo_dias_descanso_jefe character(20),categoria_jede varchar(100),id_gestor integer,codigo_gestor integer,dni_gestor character(8),nombre_gestor varchar(100),apellido_paterno_gestor varchar(100),
 		apellido_materno_gestor varchar(100),email_corp_gestor varchar(100),email_personal_gestor varchar(100),codigo_posicion_gestor character(20),descripcion_posicion_gestor varchar(100),codigo_centro_coste_gestor character(20),centro_coste_gestor varchar(100),codigo_funcion_gestor character(20),funcion_gestor varchar(100),codigo_ocupacion_gestor character(20),
 		ocupacion_gestor varchar(100),codigo_unidad_org_gestor character(20),unidad_organizativa_gestor varchar(100),fecha_nac_gestor date,inicio_contrata_gestor date,fin_contrata_gestor date,cod_jefe_gestor character(20),saldo_dias_vacaion_gestor character(20),saldo_dias_descanso_gestor character(20),categoria_gestor varchar(100),
 		sede_id integer,
 		sede_descripcion character(100),
 		sede_direccion character(150),
 		puesto_id integer,
 		puesto_des varchar(100),
 		puesto_detalle varchar(200),
 		modalidad_id integer,
 		modalidad_des varchar(100),
 		modalidad_detalle varchar(200),
 		plazo_id integer,
 		plazo_des varchar(100),
 		plazo_detalle varchar(200)
	)
	LANGUAGE 'plpgsql'
as $$
BEGIN
	RETURN QUERY
		SELECT
			sol.id,sol.id_aprobador,sol.id_jefe_directo,sol.id_puesto,sol.cantidad,sol.id_modalidad,
			sol.fecha_estimada_inicio,sol.id_plazo,sol.nombre_cliente, 
			sol.descripcion_servicio,sol.volumen_motivo,sol.inicio_estimado_tiempo,sol.estimacion_duracion_tiempo, 
			sol.observaciones,sol.descripcion,sol.remuneracion,sol.fecha_registro,sol.usuario_registro, 
			sol.fecha_modificacion,sol.usuario_modificacion,sol.estado,sol.estado as estado_des,sol.estado as estado_des1,sol.estado_vicepresidencia, 
			sol.glosa,sol.sociedad,sol.lider_uo,sol.codigo_uo,sol.descripcion_uo,sol.cod_divicion,sol.cod_sub_div, 
			sol.sctr,sol.id_area_personal,sol.id_relacion_personal,sol.file_dp,sol.direccion, 
			sol.tipo_moneda, sol.vales,sol.asig_movilidad,sol.asig_otros, 
			sol.tipo_moneda_neg, sol.remuneracion_neg ,sol.vales_neg, sol.fecha_inicio_neg, sol.file_ficha_ingreso,
			sol.codigo_area_personal, sol.area_nomina, sol.codigo_laboral,sol.cantidad_plazo,false as disabled , 
-- 			Data User
 			us.codigo as id_apro,us.codigo as codigo_user,us.sociedad as sociedad_user,us.codigo_division,us.nombre_division_personal,us.codigo_sub_division, 
 			us.nombres_sub_division,us.dni,us.nombres, us.apellido_paterno,us.apellido_materno,us.email_corp, 
 			us.email_personal,us.codigo_posicion,us.descripcion_posicion,us.codigo_centro_coste, 
 			us.centro_coste,us.codigo_funcion,us.funcion,us.codigo_ocupacion,us.ocupacion,us.codigo_unidad_org,us.unidad_organizativa, 
 			us.fecha_nac,us.inicio_contrata,us.fin_contrata,us.cod_jefe,us.saldo_dias_vacaion,us.saldo_dias_descanso,us.categoria, 
-- 			Data Jefe director
 			j_d.codigo as id_jefe,j_d.codigo as codigo_jefe_dir, j_d.dni as dni_jefe,j_d.nombres as nombre_jefe, j_d.apellido_paterno as apellido_paterno_jefe, 
 			j_d.apellido_materno as apellido_materno_jefe,j_d.email_corp as email_corp_jefe,j_d.email_personal as email_personal_jefe, 
 			j_d.codigo_posicion as codigo_posicion_jefe,j_d.descripcion_posicion as descripcion_posicion_jefe,j_d.codigo_centro_coste as codigo_centro_coste_jefe, 
 			j_d.centro_coste as centro_coste_jefe,j_d.codigo_funcion as codigo_funcion_jefe,j_d.funcion as funcion_jefe,j_d.codigo_ocupacion as codigo_ocupacion_jefe, 
 			j_d.ocupacion as ocupacion_jefe,j_d.codigo_unidad_org as codigo_unidad_org_jefe,j_d.unidad_organizativa as unidad_organizativa_jefe, 
 			j_d.fecha_nac as fecha_nac_jefe,j_d.inicio_contrata as inicio_contrata_jefe,j_d.fin_contrata as fin_contrata_jefe, 
 			j_d.cod_jefe as cod_jefe_jefe,j_d.saldo_dias_vacaion as saldo_dias_vacaion_jefe,j_d.saldo_dias_descanso as saldo_dias_descanso_jefe,j_d.categoria as categoria_jede, 
-- 			Data Gestor
 			j_g.codigo as id_gestor,j_g.codigo as codigo_gestor, j_g.dni as dni_gestor,j_g.nombres as nombre_gestor, j_g.apellido_paterno as apellido_paterno_gestor, 
 			j_g.apellido_materno as apellido_materno_gestor,j_g.email_corp as email_corp_gestor,j_g.email_personal as email_personal_gestor, 
 			j_g.codigo_posicion as codigo_posicion_gestor,j_g.descripcion_posicion as descripcion_posicion_gestor,j_g.codigo_centro_coste as codigo_centro_coste_gestor, 
 			j_g.centro_coste as centro_coste_gestor,j_g.codigo_funcion as codigo_funcion_gestor,j_g.funcion as funcion_gestor,j_g.codigo_ocupacion as codigo_ocupacion_gestor, 
 			j_g.ocupacion as ocupacion_gestor,j_g.codigo_unidad_org as codigo_unidad_org_gestor,j_g.unidad_organizativa as unidad_organizativa_gestor, 
 			j_g.fecha_nac as fecha_nac_gestor,j_g.inicio_contrata as inicio_contrata_gestor,j_g.fin_contrata as fin_contrata_gestor, 
 			j_g.cod_jefe as cod_jefe_gestor,j_g.saldo_dias_vacaion as saldo_dias_vacaion_gestor,j_g.saldo_dias_descanso as saldo_dias_descanso_gestor,j_g.categoria as categoria_gestor, 
-- 			Sede
 			se.id as sede_id, se.descripcion as sede_descripcion, se.direccion as sede_direccion,
--  		Data grupo
 			puesto.codigo as puesto_id, puesto.descripcion as puesto_des, puesto.detalle as puesto_detalle, 
 			modalidad.codigo as modalidad_id, modalidad.descripcion as modalidad_des, modalidad.detalle as modalidad_detalle,
 			plazo.codigo as plazo_id, plazo.descripcion as plazo_des, plazo.detalle as plazo_detalle 
			
			from public.solicitud as sol 
			inner join public.personal as us on us.codigo=sol.id_aprobador 
			inner join public.personal as j_d on j_d.codigo=sol.id_jefe_directo 
			inner join public.personal as j_g on j_g.codigo=sol.id_gerente 
			inner join public.general as puesto on sol.id_puesto=puesto.codigo and 'PUESTO'=rtrim(puesto.grupo) 
			inner join public.general as modalidad on sol.id_modalidad=modalidad.codigo and 'MODALIDAD'= rtrim(modalidad.grupo) 
			inner join public.general as plazo on sol.id_plazo=plazo.codigo and 'PLAZO'=rtrim(plazo.grupo) 
			left join sede as se on se.id=sol.direccion 
			where 0=0;
			
END;
$$;


-- select * from Tourist_places where name='Huancaya'

select * from get_aprobaciones_pendientes(123,1)


-- UPDATE ESTADO SOLICITUD

DROP FUNCTION put_solicitud_estado;
CREATE OR REPLACE FUNCTION put_solicitud_estado(
	estado_s integer,
	id_solicitud integer)
    RETURNS mensaje_solicitud
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	statu_s integer;
	mensaje_solicitud mensaje_solicitud;
	BEGIN
		update solicitud set estado=estado_s where id=id_solicitud
		returning estado into statu_s;
		mensaje_solicitud.text='El estado se actualiz correctamente.';
		mensaje_solicitud.estado=statu_s;
		mensaje_solicitud.id=id_solicitud;
		mensaje_solicitud.code = 'S';
		return mensaje_solicitud;
	END;
$BODY$;


select * from put_solicitud_estado(2,118)

--select * from solicitud where id=118;

CREATE TYPE mensaje_solicitud AS
(
	code character(1),
	text character varying(250),
	id integer,
	estado integer
);


-- DETALLE SOLICITUD

DROP FUNCTION get_detalle_solicitud;
CREATE OR REPLACE FUNCTION get_detalle_solicitud()
	RETURNS TABLE(id_solicitud integer,
id_grupo integer,
id_grupo_tipo varchar(50),
descripcion varchar(100),
fecha_registro date,
usuario_registro varchar(50),
fecha_nodificacion date,
usuario_modificacion varchar(50),
estado boolean,
grupo varchar(20), 
codigo integer,
detalle varchar(100),
descripcion_gen varchar(100),
activo boolean)
	LANGUAGE 'plpgsql'
AS $$
BEGIN
	RETURN QUERY
		select sd.id_solicitud,sd.id_grupo,sd.id_grupo_tipo,sd.descripcion,sd.fecha_registro,sd.usuario_registro,sd.fecha_nodificacion,
		sd.usuario_modificacion,sd.estado,gen.grupo,gen.codigo,gen.descripcion as descripcion_gen,gen.detalle,gen.activo
		from solicitud_detalle as sd 
		inner join general as gen on gen.codigo=sd.id_grupo and gen.grupo=sd.id_grupo_tipo;
END
$$;

select * from get_detalle_solicitud();



-- INSERTAR REMUNERACIONES

DROP FUNCTION put_solicitud_remuneracion;
CREATE OR REPLACE FUNCTION put_solicitud_remuneracion(
	s_tipo_moneda integer,
	s_remuneracion character(20),
	s_asig_movilidad varchar(100),
	s_vales varchar(50),
	s_asig_otros varchar(100),
	s_solicitud_id integer
)
    RETURNS mensaje_solicitud
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	solicitud_id integer;
	mensaje_solicitud mensaje_solicitud;
	BEGIN
		update solicitud set 
				tipo_moneda=s_tipo_moneda, remuneracion=s_remuneracion,
				asig_movilidad=s_asig_movilidad, vales=s_vales,asig_otros=s_asig_otros where id=s_solicitud_id
		returning id into solicitud_id;
		mensaje_solicitud.text='Remuneracion registrada correctamente.';
		mensaje_solicitud.id=solicitud_id;
		mensaje_solicitud.code = 'S';
		return mensaje_solicitud;
	END;
$BODY$;

select * from put_solicitud_remuneracion(1,'1234','123','1233','1235',101);


-- Estado 
DROP FUNCTION put_solicitud_vicepresidencia;
CREATE OR REPLACE FUNCTION put_solicitud_vicepresidencia(
	s_estado integer,
	s_estado_vicepresidencia integer,
	s_id_solicitud integer
)
    RETURNS mensaje_solicitud
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	id_solicitud_s integer;
	mensaje_solicitud mensaje_solicitud;
	BEGIN
		update solicitud set estado=s_estado, estado_vicepresidencia=s_estado_vicepresidencia where id=s_id_solicitud
		returning id into id_solicitud_s;
		mensaje_solicitud.text='Estado aprobacion actualizado correctamente.';
		mensaje_solicitud.id=id_solicitud_s;
		mensaje_solicitud.code = 'S';
		return mensaje_solicitud;
	END;
$BODY$;


select * from put_solicitud_vicepresidencia(12,5,121);
select * from put_solicitud_vicepresidencia(11,4,121);

select estado,
estado_vicepresidencia,id from solicitud where id=121;



-- Update Requerimiento 

DROP FUNCTION put_solicitud_requerimiento;
CREATE OR REPLACE FUNCTION put_solicitud_requerimiento(
	s_glosa character(100),
	s_sociedad character(100),
	s_lider_uo character(100),
	s_codigo_uo character(50),
	s_descripcion_uo character(100),
	s_cod_divicion character(50),
	s_cod_sub_div character(50),
	s_sctr character(100),
	s_id_area_personal character(100),
	s_id_relacion_personal character(100),
	s_codigo_area_personal character(100),
	s_area_nomina character(100),
	s_codigo_laboral character(100),
	s_file_dp character(500),
	s_direccion integer,
	id_solicitud integer
)
    RETURNS mensaje_solicitud
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	solicitud_id integer;
	mensaje_solicitud mensaje_solicitud;
	BEGIN
		update solicitud set 
			glosa=s_glosa, sociedad=s_sociedad, lider_uo=s_lider_uo, codigo_uo=s_codigo_uo, descripcion_uo=s_descripcion_uo,
        	cod_divicion=s_cod_divicion, cod_sub_div=s_cod_sub_div, sctr=s_sctr, id_area_personal=s_id_area_personal, 
			id_relacion_personal=s_id_relacion_personal, codigo_area_personal=s_codigo_area_personal, area_nomina=s_area_nomina, 
			codigo_laboral=s_codigo_laboral, file_dp=s_file_dp, direccion=s_direccion  
		where id=id_solicitud
		
		returning id into solicitud_id;
		mensaje_solicitud.text='Remuneracion registrada correctamente.';
		mensaje_solicitud.id=solicitud_id;
		mensaje_solicitud.code = 'S';
		return mensaje_solicitud;
	END;
$BODY$;



select * from put_solicitud_requerimiento('glosa','sociedad','lider_uo','codigo_uo','descripcion_uo','cod_divicion','cod_sub_div','sctr','id_area_personal',
		'id_relacion_personal','codigo_area_personal','area_nomina','codigo_laboral','file_dp',2,101);

select glosa,sociedad,lider_uo,codigo_uo,descripcion_uo,cod_divicion,cod_sub_div,sctr,id_area_personal,
		id_relacion_personal,codigo_area_personal,area_nomina,codigo_laboral,file_dp,direccion,id
from solicitud where id=101;



-- Get Solicitudes


DROP FUNCTION get_solicitud_all;
CREATE OR REPLACE FUNCTION get_solicitud_all(codigo_solicitud integer, cod_user integer )
	RETURNS TABLE(
		id integer,id_aprobador integer,id_jefe_directo integer,id_puesto integer,cantidad integer,id_modalidad integer,fecha_estimada_inicio date,id_plazo integer,nombre_cliente varchar(300),descripcion_servicio varchar(100),
		volumen_motivo character(20),inicio_estimado_tiempo date,estimacion_duracion_tiempo varchar(100),observaciones varchar(300),descripcion varchar(200),remuneracion character(20),fecha_registro timestamp,usuario_registro varchar(50),fecha_modificacion timestamp,usuario_modificacion varchar(50),
		estado integer,estado_des integer,estado_des1 integer,estado_vicepresidencia integer,estado_des2 integer,glosa varchar(100),sociedad varchar(100),lider_uo varchar(100),codigo_uo character(50),descripcion_uo varchar(100),
		cod_divicion varchar(50),cod_sub_div varchar(50),sctr varchar(100),id_area_personal varchar(100),id_relacion_personal varchar(100),file_dp varchar(500),direccion integer,tipo_moneda integer,vales character(50),asig_movilidad character(100),
		asig_otros character(100),tipo_moneda_neg integer,remuneracion_neg float, vales_neg character(100),fecha_inicio_neg timestamp,file_ficha_ingreso varchar(150),codigo_area_personal character(100),area_nomina character(100),codigo_laboral character(100),cantidad_plazo character(100),
		disabled boolean,id_apro integer,codigo_user integer,sociedad_user varchar(100),codigo_division character(50),nombre_division_personal varchar(100),codigo_sub_division character(50),nombres_sub_division varchar(100),dni character(8),nombres varchar(100),
		apellido_paterno varchar(100),apellido_materno varchar(100),email_corp varchar(100),email_personal varchar(100),codigo_posicion character(20),descripcion_posicion varchar(100),codigo_centro_coste character(20),centro_coste varchar(100),codigo_funcion character(20),funcion varchar(100),
		codigo_ocupacion character(20),ocupacion varchar(100),codigo_unidad_org character(20),unidad_organizativa varchar(100),fecha_nac date,inicio_contrata date,fin_contrata date,cod_jefe character(20),saldo_dias_vacaion character(20),saldo_dias_descanso character(20),
		categoria varchar(100),id_jefe integer,codigo_jefe_dir integer,dni_jefe character(8),nombre_jefe varchar(100),apellido_paterno_jefe varchar(100),apellido_materno_jefe varchar(100),email_corp_jefe varchar(100),email_personal_jefe varchar(100),codigo_posicion_jefe character(20),
		descripcion_posicion_jefe varchar(100),codigo_centro_coste_jefe character(20),centro_coste_jefe varchar(100),codigo_funcion_jefe character(20),funcion_jefe varchar(100),codigo_ocupacion_jefe character(20),ocupacion_jefe varchar(100),codigo_unidad_org_jefe character(20),unidad_organizativa_jefe varchar(100),fecha_nac_jefe date,
		inicio_contrata_jefe date,fin_contrata_jefe date,cod_jefe_jefe character(20),saldo_dias_vacaion_jefe character(20),saldo_dias_descanso_jefe character(20),categoria_jede varchar(100),id_gestor integer,codigo_gestor integer,dni_gestor character(8),nombre_gestor varchar(100),
		apellido_paterno_gestor varchar(100),apellido_materno_gestor varchar(100),email_corp_gestor varchar(100),email_personal_gestor varchar(100),codigo_posicion_gestor character(20),descripcion_posicion_gestor varchar(100),codigo_centro_coste_gestor character(20),centro_coste_gestor varchar(100),codigo_funcion_gestor character(20),funcion_gestor varchar(100),
		codigo_ocupacion_gestor character(20),ocupacion_gestor varchar(100),codigo_unidad_org_gestor character(20),unidad_organizativa_gestor varchar(100),fecha_nac_gestor date,inicio_contrata_gestor date,fin_contrata_gestor date,cod_jefe_gestor character(20),saldo_dias_vacaion_gestor character(20),saldo_dias_descanso_gestor character(20),
		categoria_gestor varchar(100),sede_id integer,sede_descripcion character(100),sede_direccion character(150),puesto_id integer,grupo_puesto varchar(100),puesto_des varchar(100),puesto_detalle varchar(200),modalidad_id integer,modalidad_grupo varchar(20),
 		modalidad_des varchar(100),
 		modalidad_detalle varchar(200),
 		plazo_id integer,
 		plazo_grupo varchar(20),
 		plazo_des varchar(100),
  		plazo_detalle varchar(200),
 		cantidad_candidato bigint
	)
	LANGUAGE 'plpgsql'
as $$
BEGIN
	RETURN QUERY
		SELECT
			sol.id,sol.id_aprobador,sol.id_jefe_directo,sol.id_puesto,sol.cantidad,sol.id_modalidad,
			sol.fecha_estimada_inicio,sol.id_plazo,sol.nombre_cliente, 
			sol.descripcion_servicio,sol.volumen_motivo,sol.inicio_estimado_tiempo,sol.estimacion_duracion_tiempo, 
			sol.observaciones,sol.descripcion,sol.remuneracion,sol.fecha_registro,sol.usuario_registro, 
			sol.fecha_modificacion,sol.usuario_modificacion,sol.estado,sol.estado as estado_des,sol.estado as estado_des1,sol.estado_vicepresidencia,sol.estado as estado_des2, 
			sol.glosa,sol.sociedad,sol.lider_uo,sol.codigo_uo,sol.descripcion_uo,sol.cod_divicion,sol.cod_sub_div, 
			sol.sctr,sol.id_area_personal,sol.id_relacion_personal,sol.file_dp,sol.direccion, 
			sol.tipo_moneda, sol.vales,sol.asig_movilidad,sol.asig_otros, 
			sol.tipo_moneda_neg, sol.remuneracion_neg ,sol.vales_neg, sol.fecha_inicio_neg,sol.file_ficha_ingreso, 
			sol.codigo_area_personal, sol.area_nomina, sol.codigo_laboral,sol.cantidad_plazo,false as disabled,
			--  data users
			us.codigo as id_apro,us.codigo as codigo_user,us.sociedad as sociedad_user,us.codigo_division,us.nombre_division_personal,us.codigo_sub_division, 
			us.nombres_sub_division,us.dni,us.nombres, us.apellido_paterno,us.apellido_materno,us.email_corp, 
			us.email_personal,us.codigo_posicion,us.descripcion_posicion,us.codigo_centro_coste, 
			us.centro_coste,us.codigo_funcion,us.funcion,us.codigo_ocupacion,us.ocupacion,us.codigo_unidad_org,us.unidad_organizativa, 
			us.fecha_nac,us.inicio_contrata,us.fin_contrata,us.cod_jefe,us.saldo_dias_vacaion,us.saldo_dias_descanso,us.categoria, 
			--  data Jefe dir
			j_d.codigo as id_jefe,j_d.codigo as codigo_jefe_dir, j_d.dni as dni_jefe,j_d.nombres as nombre_jefe, j_d.apellido_paterno as apellido_paterno_jefe, 
			j_d.apellido_materno as apellido_materno_jefe,j_d.email_corp as email_corp_jefe,j_d.email_personal as email_personal_jefe, 
			j_d.codigo_posicion as codigo_posicion_jefe,j_d.descripcion_posicion as descripcion_posicion_jefe,j_d.codigo_centro_coste as codigo_centro_coste_jefe, 
			j_d.centro_coste as centro_coste_jefe,j_d.codigo_funcion as codigo_funcion_jefe,j_d.funcion as funcion_jefe,j_d.codigo_ocupacion as codigo_ocupacion_jefe, 
			j_d.ocupacion as ocupacion_jefe,j_d.codigo_unidad_org as codigo_unidad_org_jefe,j_d.unidad_organizativa as unidad_organizativa_jefe, 
			j_d.fecha_nac as fecha_nac_jefe,j_d.inicio_contrata as inicio_contrata_jefe,j_d.fin_contrata as fin_contrata_jefe, 
			j_d.cod_jefe as cod_jefe_jefe,j_d.saldo_dias_vacaion as saldo_dias_vacaion_jefe,j_d.saldo_dias_descanso as saldo_dias_descanso_jefe,j_d.categoria as categoria_jede, 

			-- Data gestor id_gerente
			j_g.codigo as id_gestor,j_g.codigo as codigo_gestor, j_g.dni as dni_gestor,j_g.nombres as nombre_gestor, j_g.apellido_paterno as apellido_paterno_gestor, 
			j_g.apellido_materno as apellido_materno_gestor,j_g.email_corp as email_corp_gestor,j_g.email_personal as email_personal_gestor, 
			j_g.codigo_posicion as codigo_posicion_gestor,j_g.descripcion_posicion as descripcion_posicion_gestor,j_g.codigo_centro_coste as codigo_centro_coste_gestor, 
			j_g.centro_coste as centro_coste_gestor,j_g.codigo_funcion as codigo_funcion_gestor,j_g.funcion as funcion_gestor,j_g.codigo_ocupacion as codigo_ocupacion_gestor, 
			j_g.ocupacion as ocupacion_gestor,j_g.codigo_unidad_org as codigo_unidad_org_gestor,j_g.unidad_organizativa as unidad_organizativa_gestor, 
			j_g.fecha_nac as fecha_nac_gestor,j_g.inicio_contrata as inicio_contrata_gestor,j_g.fin_contrata as fin_contrata_gestor, 
			j_g.cod_jefe as cod_jefe_gestor,j_g.saldo_dias_vacaion as saldo_dias_vacaion_gestor,j_g.saldo_dias_descanso as saldo_dias_descanso_gestor,j_g.categoria as categoria_gestor, 

			--  Sede
			se.id as sede_id, se.descripcion as sede_descripcion, se.direccion as sede_direccion,

			--  data grupo
			puesto.codigo as puesto_id, puesto.grupo as puesto_grupo, puesto.descripcion as puesto_des, 
			puesto.detalle as puesto_detalle, 
			modalidad.codigo as modalidad_id, 
			modalidad.grupo as modalidad_grupo, 
			modalidad.descripcion as modalidad_des, modalidad.detalle as modalidad_detalle,
 			plazo.codigo as plazo_id, 
 			plazo.grupo as plazo_grupo, 
			plazo.descripcion as plazo_des, 
 			plazo.detalle as plazo_detalle, 
			-- Cantidad solicitante
 			(select count(*) from solicitud_candidato as s where s.id_solicitud=sol.id) as cantidad_candidato 

			
		from public.solicitud as sol 
		inner join public.personal as us on us.codigo=sol.id_aprobador 
		inner join public.personal as j_d on j_d.codigo=sol.id_jefe_directo 
		inner join public.personal as j_g on j_g.codigo=sol.id_gerente 
		inner join public.general as puesto on sol.id_puesto=puesto.codigo and 'PUESTO'=rtrim(puesto.grupo) 
		inner join public.general as modalidad on sol.id_modalidad=modalidad.codigo and 'MODALIDAD'= rtrim(modalidad.grupo) 
		inner join public.general as plazo on sol.id_plazo=plazo.codigo and 'PLAZO'=rtrim(plazo.grupo) 
		left join sede as se on se.id=sol.direccion 
		where 0=0;
			
END;
$$;


select * from get_solicitud_all(1,1);



-- INSERT CANDIDATOS

DROP FUNCTION post_solicitud_candidato_insert;

CREATE OR REPLACE FUNCTION post_solicitud_candidato_insert(
	s_id_solicitud integer,
	s_nombres varchar(100),
	s_apellido_paterno varchar(100),
	s_apellido_materno varchar(100),
	s_tipo_documento integer,
	s_numero_documento char(20),
	s_disponibilidad integer,
	s_email varchar(100),
	s_file_cv varchar(200),
	s_observaciones varchar(250),
	s_usuario_registro varchar(50)
)
    RETURNS mensaje_candidato
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	id_candidato integer;
	mensaje_candidato mensaje_candidato;
	BEGIN
		insert into solicitud_candidato (id_solicitud,nombres,apellido_paterno,apellido_materno,tipo_documento, numero_documento,
							 disponibilidad,email,file_cv,observaciones,fecha_registro,usuario_registro,estado) 
		values(s_id_solicitud,s_nombres,s_apellido_paterno ,
		s_apellido_materno ,s_tipo_documento ,
		s_numero_documento ,s_disponibilidad,s_email,s_file_cv,
		s_observaciones,now(),s_usuario_registro,1)
		returning id into id_candidato;
		mensaje_candidato.text='El estado se actualiz correctamente.';
		mensaje_candidato.id=id_candidato;
		mensaje_candidato.code = 'S';
		return mensaje_candidato;
	END;
$BODY$;

select id, id_solicitud,nombres,apellido_paterno,apellido_materno,tipo_documento, numero_documento,
	disponibilidad,email,file_cv,observaciones,fecha_registro,usuario_registro,estado
from solicitud_candidato;

select * from post_solicitud_candidato_insert(
	123,
	's_nombres varchar(100)',
	's_apellido_paterno varchar(100)',
	's_apellido_materno varchar(100)',
	1,
	'asd',
	1,
	's_email varchar(100)',
	's_file_cv varchar(200)',
	's_observaciones varchar(250)',
	'HROJAS'
);

select * from solicitud_candidato where id_solicitud=123;



-- Update Candidato


DROP FUNCTION put_solicitud_candidato_update;

CREATE OR REPLACE FUNCTION put_solicitud_candidato_update(
	s_nombres varchar(100),
	s_apellido_paterno varchar(100), 
	s_apellido_materno varchar(100),
	s_tipo_documento integer,
	s_numero_documento char(20),
	s_disponibilidad integer,
	s_email varchar(100),
	s_file_cv varchar(200),
	s_observaciones varchar(250),
	s_id_candidato integer
)
RETURNS mensaje_candidato
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	id_candidato integer;
	mensaje_candidato mensaje_candidato;
	BEGIN
		update solicitud_candidato set 
			nombres=s_nombres,apellido_paterno=s_apellido_paterno, 
			apellido_materno=s_apellido_materno,tipo_documento=s_tipo_documento, 
			numero_documento=s_numero_documento,
			disponibilidad=s_disponibilidad,email=s_email,
			file_cv=s_file_cv,observaciones=s_observaciones 
		where id=s_id_candidato
		returning id into id_candidato;
		mensaje_candidato.text='El estado se actualizo correctamente.';
		mensaje_candidato.id=id_candidato;
		mensaje_candidato.code = 'S';
		return mensaje_candidato;
	END;
$BODY$;


select * from put_solicitud_candidato_update('Test Nom','Test a', 'test',1,'50215896',1,'test@gmail.com','file candidato','Ningun Observacion',77);
	
select max(id) from solicitud_candidato;

select * from solicitud_candidato where id=77;

-- asdasdasd


DROP FUNCTION public.get_candidatos();

CREATE OR REPLACE FUNCTION public.get_candidatos(
	)
    RETURNS TABLE(id integer, id_solicitud integer, nombres character varying, apellido_paterno character varying, apellido_materno character varying, tipo_documento integer, numero_documento character, disponibilidad integer, email character varying, file_cv character varying, observaciones character varying, fecha_registro date, usuario_registro character varying, fecha_modificacion date, usuario_modificacion character varying, estado integer, estado_des character varying, id_sede_entrevista integer, contacto_sede character, fecha_entrevista timestamp without time zone, prioridad character, codigo_posicion character, codigo_trabajo text, genero integer, talla_1 text, talla_2 text, talla_3 text, email_corp character) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
DECLARE 
	estado_des_1 varchar(100) :='Activo';
	estado_des_2 varchar(100) :='Inactivo';
	BEGIN
		RETURN QUERY
			select sc.id,sc.id_solicitud,sc.nombres,sc.apellido_paterno,sc.apellido_materno,sc.tipo_documento,sc.numero_documento,sc.disponibilidad, 
			sc.email,sc.file_cv,sc.observaciones,sc.fecha_registro,sc.usuario_registro,sc.fecha_modificacion,sc.usuario_modificacion,sc.estado, 
			CASE 
			WHEN sc.estado=0 THEN estado_des_1 --'Activo'
			WHEN sc.estado=1 THEN estado_des_2 --'Inactivo'
			END as estado_des, 
			sc.id_sede_entrevista,sc.contacto_sede,sc.fecha_entrevista,sc.prioridad,sc.codigo_posicion, 
			rtrim(sc.codigo_trabajo) as codigo_trabajo, 
			sc.genero as genero,
			rtrim(sc.talla_1) as talla_1,
			rtrim(sc.talla_2) as talla_2,
			rtrim(sc.talla_3) as talla_3, 
			sc.email_corp as email_corp
			from solicitud_candidato as sc;
	END;
$BODY$;

ALTER FUNCTION public.get_candidatos()
    OWNER TO pool_recursos_qa;

select * from get_candidatos();






-- Update

DROP FUNCTION put_candidato_candidato;
CREATE OR REPLACE FUNCTION put_candidato_candidato(
	c_id_sede_entrevista integer,
 	c_contacto_sede character(100),
 	c_fecha_entrevista timestamp,
 	c_estado integer,
 	c_prioridad character(10), 
	c_id integer)
	RETURNS mensaje_candidato
	LANGUAGE 'plpgsql'
AS $$
DECLARE
	id_candidato integer;
	mensaje_candidato mensaje_candidato;
BEGIN
	update  solicitud_candidato set 
		id_sede_entrevista=c_id_sede_entrevista, 
 		contacto_sede=c_contacto_sede ,
 		fecha_entrevista=c_fecha_entrevista,
 		estado=c_estado,
  		prioridad=c_prioridad
	where id=c_id
	returning id into id_candidato;
	mensaje_candidato.text='El estado se actualizo correctamente.';
	mensaje_candidato.id=id_candidato;
	mensaje_candidato.code = 'S';
	return mensaje_candidato;
END;
$$;

select * from put_candidato_candidato(2,'COD-0001','07-10-2019',1,'123-P',27);

select * from solicitud_candidato where id=27;


-- Update 

DROP FUNCTION put_update_posicion_candidato;

CREATE OR REPLACE FUNCTION put_update_posicion_candidato(c_codigo_posicion varchar(50),c_estado integer,c_id integer)
	RETURNS mensaje_candidato
	LANGUAGE 'plpgsql'
AS $$
DECLARE
	id_candidato integer;
	mensaje_candidato mensaje_candidato;
BEGIN
	update  solicitud_candidato set codigo_posicion=c_codigo_posicion,estado=c_estado where id=c_id
	returning id into id_candidato;
	mensaje_candidato.text='El estado se actualizo correctamente.';
	mensaje_candidato.id=id_candidato;
	mensaje_candidato.code = 'S';
	return mensaje_candidato;
END;
$$;

select * from put_update_posicion_candidato('COD-0001',1,27);

select * from solicitud_candidato where id=27;





-- Upload file candidato
DROP FUNCTION post_insert_file_candidato;

CREATE OR REPLACE FUNCTION post_insert_file_candidato(c_id_candidato integer,c_name varchar(100),c_location varchar(200))
	RETURNS mensaje_candidato
	LANGUAGE 'plpgsql'
AS $$
DECLARE
	id_candidato integer;
	mensaje_candidato mensaje_candidato;
BEGIN
	insert into solicitud_candidato_archivos(id_candidato,name,location,state) 
	values(c_id_candidato,c_name,c_location,true)
	returning id into id_candidato;
	mensaje_candidato.text='El archivo se cargo correctamente.';
	mensaje_candidato.id=id_candidato;
	mensaje_candidato.code = 'S';
	return mensaje_candidato;
END;
$$;

select * from post_insert_file_candidato(27,'archivo text','123456879.txt');

select * from solicitud_candidato where id=27;

select * from solicitud_candidato_archivos where id_candidato=27;



-- Delete file 

DROP FUNCTION put_update_file_candidato;

CREATE OR REPLACE FUNCTION put_update_file_candidato(a_state boolean,a_id integer)
	RETURNS mensaje_candidato
	LANGUAGE 'plpgsql'
AS $$
DECLARE
	id_candidato integer;
	mensaje_candidato mensaje_candidato;
BEGIN
	update solicitud_candidato_archivos set state=a_state where id=a_id
	returning id into id_candidato;
	mensaje_candidato.text='El archivo fue borrado correctamente.';
	mensaje_candidato.id=id_candidato;
	mensaje_candidato.code = 'S';
	return mensaje_candidato;
END;
$$;

select * from put_update_file_candidato(false,22);




-- Get all file candidato

DROP FUNCTION get_all_file_candidato();
CREATE OR REPLACE FUNCTION get_all_file_candidato()
	RETURNS TABLE(id_candidato integer,id integer,name varchar(100),location varchar(200),state boolean)
	LANGUAGE 'plpgsql'
AS $$
BEGIN
	RETURN QUERY
	select s.id_candidato ,s.id,s.name,s.location,s.state from solicitud_candidato_archivos as s where s.state=true;
END;
$$;

SELECT * FROM get_all_file_candidato();



-- Update remuneracion negociable

DROP FUNCTION put_remuneracion_negociable;

CREATE OR REPLACE FUNCTION put_remuneracion_negociable(
	c_id integer,
	c_tipo_moneda_neg integer,
	c_remuneracion_neg float, 
 	c_vales_neg character(100),
 	c_fecha_inicio_neg timestamp,
 	c_file_ficha_ingreso character(150)
)
	RETURNS mensaje_solicitud
	LANGUAGE 'plpgsql'
AS $$
DECLARE
	id_solicitud integer;
	mensaje_solicitud mensaje_solicitud;
BEGIN
	update solicitud set  
		tipo_moneda_neg=c_tipo_moneda_neg,
		remuneracion_neg=c_remuneracion_neg,
 		vales_neg=c_vales_neg,
 		fecha_inicio_neg=c_fecha_inicio_neg,
 		file_ficha_ingreso=c_file_ficha_ingreso 
	where id=c_id 

	returning id into id_solicitud;
	mensaje_solicitud.text='Renumeracion negociable guardado correctamente.';
	mensaje_solicitud.id=id_solicitud;
	mensaje_solicitud.code = 'S';
	return mensaje_solicitud;
END;
$$;

select * from put_remuneracion_negociable(129,2,3000, '1234','07-10-2019','1570230395770.pdf');



-- Get get_solicitud_baja_deuda

DROP FUNCTION get_solicitud_baja_deuda;

CREATE OR REPLACE FUNCTION get_solicitud_baja_deuda(c_id_solicitud integer, c_id_tipo integer)
RETURNS TABLE (
	id_solicitud integer,
	id_tipo integer,
	monto float,
	estado integer,
	usuario_creacion varchar(50),
	fecha_creacion date,
	usuario_modificacion varchar(50),
	fecha_modificacion date,
	tipo_moneda	integer
)
LANGUAGE 'plpgsql'
AS $$
BEGIN 
RETURN QUERY
	select 
		sbd.id_solicitud,sbd.id_tipo,sbd.monto,sbd.estado,sbd.usuario_creacion,sbd.fecha_creacion,
		sbd.usuario_modificacion,sbd.fecha_modificacion,sbd.tipo_moneda 
	from solicitud_baja_deuda as sbd where sbd.id_solicitud=c_id_solicitud and sbd.id_tipo=c_id_tipo;
END;
$$;

select * from get_solicitud_baja_deuda(15,1);




-- Insert And Update Solicitud baja deuda Deuda

DROP FUNCTION put_solicitud_baja_deuda;
CREATE OR REPLACE FUNCTION put_solicitud_baja_deuda(
	sbd_id_tipo integer,
	sbd_tipo_moneda integer,
	sbd_monto float, 
 	sbd_estado integer,
	sbd_id_solicitud integer
)
	RETURNS mensaje_solicitud
	LANGUAGE 'plpgsql'
AS $$
DECLARE
	id_solicitud_baja integer;
	mensaje_solicitud mensaje_solicitud;
BEGIN
	update solicitud_baja_deuda set id_tipo=sbd_id_tipo, tipo_moneda=sbd_tipo_moneda, monto=sbd_monto, estado=sbd_estado where id_solicitud=sbd_id_solicitud

	returning id_solicitud into id_solicitud_baja;
	mensaje_solicitud.text='Renumeracion negociable guardado correctamente.';
	mensaje_solicitud.id=id_solicitud_baja;
	mensaje_solicitud.code = 'S';
	return mensaje_solicitud;
END;
$$;

select * from put_solicitud_baja_deuda(1,2,'123.1230', 0,15);



-- Insert solicitud baja

DROP FUNCTION post_solicitud_baja_deuda;
CREATE OR REPLACE FUNCTION post_solicitud_baja_deuda(
	sbd_id_solicitud integer,
	sbd_id_tipo integer,
	sbd_tipo_moneda integer,
	sbd_monto float, 
	sbd_estado integer,
	sbd_usuario_creacion varchar(50)
)
	RETURNS mensaje_solicitud
	LANGUAGE 'plpgsql'
AS $$
DECLARE
	id_solicitud_baja integer;
	mensaje_solicitud mensaje_solicitud;
BEGIN
	insert into solicitud_baja_deuda(id_solicitud,id_tipo,tipo_moneda,monto,estado,usuario_creacion,fecha_creacion)
	values(sbd_id_solicitud,sbd_id_tipo,sbd_tipo_moneda,sbd_monto,sbd_estado,sbd_usuario_creacion,now())
	returning id_solicitud into id_solicitud_baja;
	mensaje_solicitud.text='La deuda se guardado correctamente.';
	mensaje_solicitud.id=id_solicitud_baja;
	mensaje_solicitud.code = 'S';
	return mensaje_solicitud;
END;
$$;

select * from post_solicitud_baja_deuda(15,2,1,'123.1230', 0,'HROJAS');




-- Update estado solicitud baja

DROP FUNCTION put_estado_solicitud_baja;
CREATE OR REPLACE FUNCTION put_estado_solicitud_baja(
	sb_estado integer,
	sb_id integer
)
	RETURNS mensaje_solicitud
	LANGUAGE 'plpgsql'
AS $$
DECLARE
	id_solicitud_baja integer;
	mensaje_solicitud mensaje_solicitud;
BEGIN
	update solicitud_baja set estado=sb_estado where id=sb_id
	returning id into id_solicitud_baja;
	mensaje_solicitud.text='Los cambios se guardaron correctamente.';
	mensaje_solicitud.id=id_solicitud_baja;
	mensaje_solicitud.code = 'S';
	return mensaje_solicitud;
END;
$$;

select * from put_estado_solicitud_baja(1,15);





-- Get solicitud baja

DROP FUNCTION get_solicitud_baja_deuda_detalle;
CREATE OR REPLACE FUNCTION get_solicitud_baja_deuda_detalle(c_id_solicitud integer)
	RETURNS TABLE(
			id_solicitud integer,
			id_tipo integer,
			monto float,
			usuario_creacion varchar(50),
			fecha_creacion date,
			usuario_modificacion varchar(50),
			fecha_modificacion date,
			tipo_moneda integer,
			estado integer
	)
	LANGUAGE 'plpgsql'
AS $$
BEGIN
	RETURN QUERY
	select sbd.id_solicitud,sbd.id_tipo,sbd.monto,sbd.usuario_creacion,sbd.fecha_creacion,sbd.usuario_modificacion,
			sbd.fecha_modificacion,sbd.tipo_moneda,sbd.estado
	from solicitud_baja_deuda as sbd where sbd.id_solicitud=c_id_solicitud;
END;
$$;

select * from get_solicitud_baja_deuda_detalle(15);






DROP FUNCTION get_personal_list();

CREATE OR REPLACE FUNCTION get_personal_list()
	RETURNS TABLE (
		estado1 boolean,estado2 boolean,codigo integer,sociedad varchar(100),codigo_divicion character(50),
		nombre_divicion_personal varchar(100),codigo_sub_division character(50),nombres_sub_division varchar(100),dni character(8),nombres varchar(100),
		apellido_paterno varchar(100),apellido_materno varchar(100),email_corp varchar(100),email_personal varchar(100),codigo_posicion character(20),
		descripcion_posicion varchar(100),codigo_centro_coste character(20),centro_coste varchar(100), codigo_funcion character(20), funcion varchar(100),
		codigo_ocupacion character(20), ocupacion varchar(100), codigo_unidad_org character(20), unidad_organizativa varchar(100),fecha_nac date, 
		inicio_contrata date, fin_contrata date, cod_jefe character(20), saldo_dias_vacaion character(20),saldo_dias_descanso character(20), 
		categoria varchar(100), tipo_documento character(20), state boolean, periodo character(100),periodo_des character(100)
	)
	LANGUAGE 'plpgsql'
AS $$
BEGIN
	RETURN QUERY 
		select per.state as estado_1, per.state as estado_2,  per.* from personal as per;
	
END;
$$;


select * from get_personal_list();



-- Test  array insert

DROP FUNCTION data_array_test1;

CREATE OR REPLACE FUNCTION public.data_array_test1(id_grupo text[],id_grupo_tipo text[])
    RETURNS TABLE(id integer, id_grupo text,id_grupo_tipo text)
    LANGUAGE sql
STRICT
AS $BODY$
-- 		RETURN QUERY
		SELECT 1 as id, unnest(id_grupo) as id_grupo, unnest(id_grupo_tipo) as id_grupo_tipo;
		
$BODY$;




INSERT INTO solicitud_detalle(id_solicitud,id_grupo,id_grupo_tipo,descripcion,fecha_registro,usuario_registro,estado)
SELECT	144,1,'TEST','', now(),'HROJASTEST',true;

values(c_id_solicitud,c_id_grupo,c_id_grupo_tipo,'',now(),c_usuario_registro,true)

select * from solicitud_detalle;

server send data
-- // var test=`select * from data_array_test1('{${id_grupo}}','{${id_grupo_tipo}}')`;







-- Menu Permisos

CREATE TABLE menu(
	id int not null primary key,
	collapse varchar(100) not null, 
	name varchar(100) not null,
	icon varchar(100) not null,
	state varchar(100) not null,
	path varchar(100) not null,
	component varchar(100) not null,
	layout varchar(100) not null,
	nivel char(50) not null,
	parent int not null,
	usuario_registro varchar(100) not null,
	fecha_registro timestamp not null,
	usuario_modificacion varchar(100) null,
	fecha_modificacion timestamp null,
	estado boolean not null
)

ALTER TABLE menu
ADD COLUMN orden integer null;

ALTER TABLE menu
ALTER COLUMN nivel TYPE int USING nivel::integer;


 
CREATE SEQUENCE id_menu;
ALTER TABLE menu ALTER id SET DEFAULT NEXTVAL('id_menu');

select * from menu;

insert into menu(collapse,name,icon,state,path,component,layout,nivel,parent,usuario_registro,fecha_registro,estado)
values(true,'Playground','ni ni-ui-04 text-info','componentsCollapse','#','','',1,0,'HROJAS',now(),true)

insert into menu(collapse,name,icon,state,path,component,layout,nivel,parent,usuario_registro,fecha_registro,estado)
values(true,'Seguimiento de Renovaciones','ni ni-archive-2 text-green','','/Seguimientorenovacion','Seguimientorenovacion','/pages',14,1,'HROJAS',now(),true)


select * from rol;


CREATE TABLE rol(
	id int not null primary key,
	descripcion varchar(100) not null,
	usuario_registro varchar(100) not null,
	fecha_registro varchar(100) not null, 
	usuario_modificacion varchar(100) null,
	fecha_modificacion timestamp null,
	estado boolean
)

CREATE SEQUENCE id_rol;
ALTER TABLE rol ALTER id SET DEFAULT NEXTVAL('id_rol');


select * from rol;


insert into rol(descripcion,usuario_registro,fecha_registro,estado)
values('Sistema','Hrojas',now(),true);







DROP TABLE rol_menu;
CREATE TABLE rol_menu(
	id_rol int not null,
	id_menu int not null,
	usuario_registro varchar(100) not null,
	fecha_registro timestamp not null,
	usuario_modificacion varchar(100) null,
	fecha_modificacion timestamp null,
	estado boolean,
	primary key (id_rol,id_menu),
	foreign key (id_rol) references rol(id),
	foreign key (id_menu) references menu(id)
)

select * from rol_menu;

insert into rol_menu(id_rol,id_menu,usuario_registro,fecha_registro,estado)
values
(3,1,'HROJAS',now(),true),
(3,2,'HROJAS',now(),true),
(3,3,'HROJAS',now(),true),
(3,4,'HROJAS',now(),true),
(3,5,'HROJAS',now(),true),
(2,6,'HROJAS',now(),true),
(2,7,'HROJAS',now(),true),
(2,8,'HROJAS',now(),true),
(2,9,'HROJAS',now(),true),
(2,10,'HROJAS',now(),true),
(2,11,'HROJAS',now(),true),
(2,12,'HROJAS',now(),true),
(2,13,'HROJAS',now(),true),
(2,14,'HROJAS',now(),true),
(2,15,'HROJAS',now(),true);



DROP table persona_rol;
CREATE TABLE persona_rol(
	email varchar(100) not null,
	id_rol int not null,
	descripcion varchar(100) not null,
	usuario_registro varchar(100) not null,
	fecha_registro timestamp not null,
	usuario_modificacion varchar(100) null,
	fecha_modificacion timestamp null,
	estado int not null,
	primary key (email),
	foreign key(id_rol) references rol(id)
)

select * from persona_rol;
ALTER TABLE persona_rol
ALTER COLUMN estado type boolean USING estado::boolean


insert into persona_rol(email,id_rol,descripcion,usuario_registro,fecha_registro,estado)
values('hrojas@summit.com.pe',1,'','HROJAS',now(),true),
('hernanrojasutani@gmail.com',3,'','HROJAS',now(),true),
('rojasutanihernan@gmail.com',4,'','HROJAS',now(),true),
('rojas_utan_21@hotmail.es',1,'','HROJAS',now(),true),
('rojas_utan_21@hotmail.com',2,'','HROJAS',now(),true),
('hernan_rojas_21@hotmail.com',4,'','HROJAS',now(),true);





select * from menu;



DROP FUNCTION get_menu();
CREATE FUNCTION get_menu()
	RETURNS TABLE(
		id int,
		collapse boolean, 
		name varchar(100),
		icon varchar(100),
		state varchar(100),
		path varchar(100),
		component varchar(100),
		layout varchar(100),
		nivel integer,
		parent int,
		usuario_registro varchar(100),
		fecha_registro timestamp,
		usuario_modificacion varchar(100),
		fecha_modificacion timestamp,
		estado boolean,
		orden integer
	)
	LANGUAGE 'plpgsql'
AS $$
BEGIN
	RETURN QUERY
		SELECT me.* FROM menu as me;
END;
$$;

select * from get_menu();



SELECT 
	M.MENU,
	M.DESCRIPCION,
	M.HREF,
	M.NIVEL,
	M.PADRE,
	M.ORDEN 
FROM USUARIO U INNER JOIN MENU_PERMISO P ON U.GRUPO_USUARIO = P.GRUPO_USUARIO 
INNER JOIN MENU M ON M.MENU = P.MENU
WHERE U.USUARIO=? AND M.NIVEL=?



DROP FUNCTION get_menu_permiso;
CREATE FUNCTION get_menu_permiso(user_permiso varchar(100))
	returns table (
		id integer,
		collapse boolean,
		name varchar(100),
		icon varchar(100),
		state varchar(100),
		path varchar(100),
		component varchar(100),
		layout varchar(100),
		nivel integer,
		parent integer,
		orden integer,
		estado boolean
	)
	LANGUAGE 'plpgsql'
AS $$
BEGIN
	RETURN QUERY
	SELECT 
		me.id,
		me.collapse,
		me.name,
		me.icon,
		me.state,
		me.path,
		me.component,
		me.layout,
		me.nivel,
		me.parent,
		me.orden,
		me.estado
	FROM persona_rol AS pr
	INNER JOIN rol_menu AS rm ON pr.id_rol = rm.id_rol
	INNER JOIN menu AS me ON me.id=rm.id_menu
	WHERE pr.email=user_permiso;
END;
$$;



select * from get_menu_permiso('hrojas@summit.com.pe');
select * from get_menu_permiso('hernanrojasutani@gmail.com');





SELECT * 

FROM persona_rol AS pr
INNER JOIN rol_menu AS rm ON pr.id_rol = rm.id_rol
INNER JOIN menu AS me ON me.id=rm.id_menu
WHERE email='hrojas@summit.com.pe';

select * from ROL_MENU;
SELECT * FROM MENU;


-- ORDER BY M.ORDEN

-- ORDER BY M.PADRE,M.ORDEN


select * from solicitud order by id desc limit 10 offset 30;

select count(id) as total from solicitud;