﻿
namespace Modelo
{
    public class clsIdioma
    {
        private int numIdIdioma;

        public int IdIdioma
        {
            get { return numIdIdioma; }
            set { numIdIdioma = value; }
        }
        private string strNombre;

        public string Nombre
        {
            get { return strNombre; }
            set { strNombre = value; }
        }
        private string strDescripcion;

        public string Descripcion
        {
            get { return strDescripcion; }
            set { strDescripcion = value; }
        }
        private string strEstado;

        public string Estado
        {
            get { return strEstado; }
            set { strEstado = value; }
        }

        public override string ToString()
        {
            return Nombre;
        }

        public clsIdioma()
        {
            IdIdioma = 0;
            Nombre = "";
            Descripcion = "";
            Estado = "ACTIVO";
        }
    }
}
