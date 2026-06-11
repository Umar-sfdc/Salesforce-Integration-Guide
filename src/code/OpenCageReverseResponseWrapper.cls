public class OpenCageReverseResponseWrapper{
	public results[] results;

	public class results {
		public components components;
		public Integer confidence;
		public String formatted;
		public geometry geometry;
	}

	public class components {
		public String city;
		public String city_district;
		public String continent;
		public String country;
		public String country_code;
		public String county;
		public String house_number;
		public String office;
		public String political_union;
		public String postcode;
		public String road;
		public String state;
		public String state_code;
		public String suburb;
	}

	public class geometry {
		public Double lat;
		public Double lng;
	}
}