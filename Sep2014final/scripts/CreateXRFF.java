import java.io.File;
import java.util.ArrayList;
import java.util.List;

import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;
import weka.core.converters.XRFFSaver;

/**
 * Class transforming data set to its xrff representation - where each instance can have weight added
 * 
 * @author Natalia Paszkiewicz
 */
public class CreateXRFF {

	
	public static void xrffConverter(String fileName, String directory)
			throws Exception {
		// assuming that folder 0 contains original datasets, folder 1 contains datasets with weights from variant_1 ...
		for (int katalog = 0; katalog <= 2; katalog++) {
			String fullPath = directory + katalog + "\\";
			DataSource source = new DataSource(fullPath + fileName + ".csv");			
			Instances data = source.getDataSet();
			if (katalog != 0) {
				// get index of weight attribute
				int wIndex = data.numAttributes() - 1;
				// set instances weights
				for (int i = 0; i < data.numInstances(); i++) {
					double weight = data.instance(i).value(wIndex);
					data.instance(i).setWeight(weight);
				}

				System.out.println("Removing attribute weight");
				data.deleteAttributeAt(wIndex);
			}

			System.out.println("Attributes final number "
					+ data.numAttributes());
			if (data.classIndex() == -1)
				data.setClassIndex(data.numAttributes() - 1);

			// save data
			XRFFSaver saver = new XRFFSaver();
			saver.setFile(new File(fullPath + fileName + ".xrff"));
			saver.setInstances(data);
			saver.writeBatch();
		}
	}

	public static void main(String[] args) throws Exception {

		List<String> fileNames = new ArrayList<String>();
		fileNames.add("WQR5");
		for (String fileName : fileNames)
			CreateXRFF.xrffConverter(fileName, args[1]);

	}
}